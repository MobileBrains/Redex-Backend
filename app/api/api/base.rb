require 'grape'

module API
  class Base < Grape::API
    mount API::V1::API
  end
end