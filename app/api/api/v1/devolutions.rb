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
          optional :observation, type: String, desc: "Optional observation"
          requires :delivery_order_internal_guide, type: String, desc: "Delivery order Internal Guide"
          optional :image_url, type: String, desc: "URL for Delivery order Image"
          requires :delivery_order_id, type: Integer, desc: "Delivery Order Id"

        end
        post do
          delivery_order = DeliveryOrder.where(internal_guide: permitted_params[:delivery_order_internal_guide]).where(state:0).first

          if delivery_order.present?
            delivery_order.update_attributes(:state => 2,:delivered_at => Time.now)

            devolution = Devolution.create({devolution_reason: permitted_params[:devolution_reason],
                                          observation: permitted_params[:observation],
                                          delivery_order_internal_guide: permitted_params[:delivery_order_internal_guide],
                                          image: permitted_params[:image_url],
                                          delivery_order_id: permitted_params[:delivery_order_id],
                                          user_id: current_user.id})

            delivery_order.image = devolution.image
            puts("imagen: "+ delivery_order.image)
            delivery_order.save

            if devolution.devolution_reason = 1
              devolutions_count = Devolution.devolutions_count(permitted_params[:delivery_order_internal_guide])
              if devolutions_count > 2
                puts "!Atencion¡ Es la devolucion numero: #{devolutions_count}"
              end
            end

            present :devolution, devolution, with: DevolutionEntity
          end
        end

      end
    end
  end
end