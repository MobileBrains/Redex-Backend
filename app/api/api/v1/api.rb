require 'grape'

module API
  module V1
    class API < Grape::API
      mount API::Users
      mount API::Sessions
      mount API::DeliveryOrders
      mount API::Devolutions
    end
  end
end