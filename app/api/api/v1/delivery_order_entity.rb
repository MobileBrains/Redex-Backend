require 'grape-entity'

module API
  module V1
    class DeliveryOrderEntity < Grape::Entity
      expose :id
      expose :radication_at
      expose :delivered_at
      expose :charge_number
      expose :delivery_man
      expose :city
      expose :internal_guide
      expose :destinatary
      expose :adderss
      expose :client
      expose :externa_guide
      expose :state
      expose :image
      expose :created_at
    end
  end
end