module API
  module V1
    class Users < Grape::API
      include APIDefaults
      include APIGuard

      guard_all!

      resource :users do
        desc "Return all users"
        get "" do
          users = User.all
          present :users, users, with: UserEntity
        end

        desc "Return a user by ID"
        params do
          requires :id, type: Integer, desc: "ID of the user"
        end
        get ":id" do
          user = User.where(id: permitted_params[:id]).first!
          present :users, user, with: UserEntity
        end

        desc "Get all delivery orders for the authenticated user"
        post "/orders" do
          delivery_orders = DeliveryOrder.where(:delivery_man => current_user.name).order('state asc')
          present :delivery_orders, delivery_orders, with: DeliveryOrderEntity
        end
      end
    end
  end
end