# == Schema Information
#
# Table name: mail_delivery_offices
#
#  id                       :integer          not null, primary key
#  name                     :string
#  address                  :string
#  email                    :string
#  phone                    :integer
#  latitude                 :float
#  longitude                :float
#  user_id                  :integer
#  image                    :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  mail_delivery_company_id :integer
#

class MailDeliveryOffice < ApplicationRecord

  belongs_to :mail_delivery_company
  has_many :users
  belongs_to :mail_delivery_office_manager, :class_name => "User", foreign_key: :user_id

  has_many :delivery_order

  geocoded_by :address
  after_validation :geocode, if: -> {self.address? or self.address_changed? }#after_validation :geocode
end
