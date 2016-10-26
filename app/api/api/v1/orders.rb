module API
  module V1
    class Orders < Grape::API
      include APIDefaults
      include APIGuard

      guard_all!

      resource :orders do
        desc "Upload a order image"
        params do
          requires :image_url, type: String, desc: "URL of image's order"
        end
        post '/image' do
          result = { image_url: permitted_params[:image_url]}

          present :order, result, with: OrderEntity
        end
      end
    end
  end
end