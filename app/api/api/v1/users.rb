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

        desc "Update user location"
        params do
          requires :longitude, type: Float, desc: "Longitude coordinates"
          requires :latitude, type: Float, desc: "Latitude coordinates"
          optional :location_type, type: Float, desc: "Location Type"
          optional :image_url, type: String, desc: "url for image"
        end
        post "/updateLocation" do
          user = User.where(:id => current_user.id).first
          if user.present?
            user.update_attributes(:latitude => permitted_params[:latitude], :longitude => permitted_params[:longitude])

            courrierLocation = CourriersLocation.create({latitude: permitted_params[:latitude],
                                          longitude: permitted_params[:longitude],
                                          location_type: permitted_params[:location_type],
                                          image: permitted_params[:image_url],
                                          user_id: current_user.id})
            courrierLocation.save
            present :user, user,with: UserEntity
          else
            return "No fue posible actualizar ubicacion, intente de nuevo."
          end
        end

      end
    end
  end
end