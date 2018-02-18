module API
  module V1
    class DeliveryOrders < Grape::API
      include APIDefaults
      include APIGuard

      guard_all!

      resource :delivery_orders do
        desc "Upload an order image"
        params do
          requires :delivery_order_id, type: Integer, desc: "ID of Delivery order"
          requires :image_url, type: String, desc: "Image URL of Delivery order"
        end
        post "/image" do
          delevery_order = DeliveryOrder.find(permitted_params[:delivery_order_id])
          delevery_order.update_attributes(:image => permitted_params[:image_url], :state => 1, :delivered_at => Time.now) if delevery_order.present?
          present :delevery_order, delevery_order, with: DeliveryOrderEntity
        end

        desc "Change delivery order state to ENTREGADA"
        params do
          requires :delivery_order_internal_guide, type: String, desc: "Delivery order Internal Guide"
          requires :longitude, type: Float, desc: "Longitude coordinates"
          requires :latitude, type: Float, desc: "Latitude coordinates"
        end
        post "/delivered" do
          delivery_order = DeliveryOrder.where(internal_guide: permitted_params[:delivery_order_internal_guide]).where(state:0).first
          if delivery_order.present?
            delivery_order.update_attributes(:state => 1, :delivered_at => Time.now, :latitude => permitted_params[:latitude], :longitude => permitted_params[:longitude])
            present :delivery_order, delivery_order,with: DeliveryOrderEntity
          else
            return "Numero de Guia interna equivocado o no existe."
          end

        end

      end
    end
  end
end