# == Schema Information
#
# Table name: users
#
#  id                      :integer          not null, primary key
#  email                   :string           default(""), not null
#  encrypted_password      :string           default(""), not null
#  reset_password_token    :string
#  reset_password_sent_at  :datetime
#  remember_created_at     :datetime
#  sign_in_count           :integer          default(0), not null
#  current_sign_in_at      :datetime
#  last_sign_in_at         :datetime
#  current_sign_in_ip      :inet
#  last_sign_in_ip         :inet
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  name                    :string
#  latitude                :float
#  longitude               :float
#  location                :string
#  mail_delivery_office_id :integer
#

class User < ApplicationRecord
  has_one :mail_delivery_company
  belongs_to :mail_delivery_office
  belongs_to :client, optional: true

  has_many :devolutions
  after_create :assign_default_role

  has_many :courriers_location

  geocoded_by :byCoordinates
  reverse_geocoded_by :latitude, :longitude, :address => :location
  after_validation :reverse_geocode, if: -> {self.longitude.present? and self.latitude.present? and self.longitude_changed? or self.latitude_changed?  }   # auto-fetch address

  def byCoordinates
    [latitude, longitude].compact.join(', ')
  end


  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
       :recoverable, :rememberable, :trackable, :validatable

  def assign_default_role
    self.add_role(:newuser) if self.roles.blank?
  end
end
