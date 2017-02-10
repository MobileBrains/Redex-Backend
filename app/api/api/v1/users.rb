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

        desc "Update courrier location"
        params do
          requires :user_id, type: Integer, desc: "user uniqe id"
          requires :longitude, type: Float, desc: "Longitude coordinates"
          requires :latitude, type: Float, desc: "Latitude coordinates"
        end

        post "/updateLocation" do
          user = User.where(id: permitted_params[:user_id]).first
          if user.present?
            user.update_attributes(:latitude => permitted_params[:latitude], :longitude => permitted_params[:longitude])
            present :user, user,with: UserEntity
          else
            return "Numero de Guia interna equivocado o no existe."
          end
        end

      end
    end
  end
end