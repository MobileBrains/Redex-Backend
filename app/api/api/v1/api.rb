require 'grape'

module API
  module V1
    class API < Grape::API
      mount API::Users
    end
  end
end