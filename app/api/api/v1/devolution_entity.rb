require 'grape-entity'

module API
  module V1
    class DevolutionEntity < Grape::Entity
      expose :id
      expose :observation
      expose :delivery_order_internal_guide
      expose :user_id
      expose :created_at
      expose :updated_at
    end
  end
end