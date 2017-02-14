class MailDeliveryCompany < ApplicationRecord
  belongs_to :user

  geocoded_by :address
  after_validation :geocode, if: -> {self.address? or self.address_changed? }#after_validation :geocode


end
