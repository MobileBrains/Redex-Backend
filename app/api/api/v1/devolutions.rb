module API
  module V1
    class Devolutions < Grape::API
      include APIDefaults
      include APIGuard

      guard_all!

      resource :devolutions do
        desc "Save a register for a devolution notification"
        params do

          requires :devolution_reason, type: Integer, desc: "Devolution reason"
          requires :observation, type: String, desc: "Optional observation"
          requires :delivery_order_internal_guide, type: String, desc: "Delivery order Internal Guide"

        end

        post do
          puts "ACA: #{permitted_params}"
          delivery_order = DeliveryOrder.where(internal_guide: permitted_params[:delivery_order_internal_guide]).where(state:0).first

          if delivery_order.present?
            delivery_order.update_attributes(:state => 2)
            devolution = Devolution.create({devolution_reason: permitted_params[:devolution_reason],
                                          observation: permitted_params[:observation],
                                          delivery_order_internal_guide: permitted_params[:delivery_order_internal_guide],
                                          user_id: current_user.id})
            present :devolution, devolution, with: DevolutionEntity
          end
        end
      end
    end
  end
end