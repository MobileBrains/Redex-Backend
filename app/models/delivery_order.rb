# == Schema Information
#
# Table name: delivery_orders
#
#  id                      :integer          not null, primary key
#  radication_at           :datetime
#  delivered_at            :datetime
#  charge_number           :integer
#  delivery_man            :string
#  city                    :string
#  internal_guide          :string
#  destinatary             :string
#  address                 :string
#  client                  :string
#  externa_guide           :string
#  state                   :integer          default("pendiente")
#  image                   :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  latitude                :float
#  longitude               :float
#  mail_delivery_office_id :integer
#  uploaded_by             :integer
#

class DeliveryOrder < ApplicationRecord
  has_one :devolution
  belongs_to :mail_delivery_office

  geocoded_by :addressJoin
  reverse_geocoded_by :latitude, :longitude
  after_validation :geocode

  scope :ordenedByDeliveredDate, -> { order 'delivered_at ASC' }

  def addressJoin
    [address, city].compact.join(', ')
  end

  #after_validation :reverse_geocode, if: ->(DeliveryOrder){ DeliveryOrder.address.present? and DeliveryOrder.address_changed? }  # auto-fetch address

  enum state: { pendiente: 0,
                entregada: 1,
                devolucion: 2
              }
end
