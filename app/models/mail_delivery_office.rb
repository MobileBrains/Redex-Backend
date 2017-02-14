class MailDeliveryOffice < ApplicationRecord

  belongs_to :mail_delivery_company
  has_many :user

  geocoded_by :address
  after_validation :geocode, if: -> {self.address? or self.address_changed? }#after_validation :geocode
end
