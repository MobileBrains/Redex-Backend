# == Schema Information
#
# Table name: mail_delivery_companies
#
#  id         :integer          not null, primary key
#  name       :string
#  address    :string
#  email      :string
#  phone      :integer
#  latitude   :float
#  longitude  :float
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  image      :string
#

class MailDeliveryCompany < ApplicationRecord
  belongs_to :mail_delivery_company_manager, :class_name => "User", foreign_key: :user_id
  has_many :mail_delivery_office

  geocoded_by :address
  after_validation :geocode, if: -> {self.address? or self.address_changed? }#after_validation :geocode

end
