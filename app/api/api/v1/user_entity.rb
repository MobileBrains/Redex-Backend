require 'grape-entity'

module API
  module V1
    class UserEntity < Grape::Entity
      expose :id
      expose :email
      expose :name
      expose :created_at
    end
  end
end