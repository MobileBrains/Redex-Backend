require 'grape-entity'

module API
  module V1
    class OrderEntity < Grape::Entity
      expose :image_url
    end
  end
end