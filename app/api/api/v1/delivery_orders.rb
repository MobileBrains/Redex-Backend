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
      end
    end
  end
end