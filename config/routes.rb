# == Route Map
#
#                        Prefix Verb   URI Pattern                                  Controller#Action
#                               GET    /oauth/authorize/:code(.:format)             doorkeeper/authorizations#show
#           oauth_authorization GET    /oauth/authorize(.:format)                   doorkeeper/authorizations#new
#                               POST   /oauth/authorize(.:format)                   doorkeeper/authorizations#create
#                               DELETE /oauth/authorize(.:format)                   doorkeeper/authorizations#destroy
#                   oauth_token POST   /oauth/token(.:format)                       doorkeeper/tokens#create
#                  oauth_revoke POST   /oauth/revoke(.:format)                      doorkeeper/tokens#revoke
#            oauth_applications GET    /oauth/applications(.:format)                doorkeeper/applications#index
#                               POST   /oauth/applications(.:format)                doorkeeper/applications#create
#         new_oauth_application GET    /oauth/applications/new(.:format)            doorkeeper/applications#new
#        edit_oauth_application GET    /oauth/applications/:id/edit(.:format)       doorkeeper/applications#edit
#             oauth_application GET    /oauth/applications/:id(.:format)            doorkeeper/applications#show
#                               PATCH  /oauth/applications/:id(.:format)            doorkeeper/applications#update
#                               PUT    /oauth/applications/:id(.:format)            doorkeeper/applications#update
#                               DELETE /oauth/applications/:id(.:format)            doorkeeper/applications#destroy
# oauth_authorized_applications GET    /oauth/authorized_applications(.:format)     doorkeeper/authorized_applications#index
#  oauth_authorized_application DELETE /oauth/authorized_applications/:id(.:format) doorkeeper/authorized_applications#destroy
#              oauth_token_info GET    /oauth/token/info(.:format)                  doorkeeper/token_info#show
#              new_user_session GET    /users/sign_in(.:format)                     devise/sessions#new
#                  user_session POST   /users/sign_in(.:format)                     devise/sessions#create
#          destroy_user_session DELETE /users/sign_out(.:format)                    devise/sessions#destroy
#                 user_password POST   /users/password(.:format)                    devise/passwords#create
#             new_user_password GET    /users/password/new(.:format)                devise/passwords#new
#            edit_user_password GET    /users/password/edit(.:format)               devise/passwords#edit
#                               PATCH  /users/password(.:format)                    devise/passwords#update
#                               PUT    /users/password(.:format)                    devise/passwords#update
#      cancel_user_registration GET    /users/cancel(.:format)                      devise/registrations#cancel
#             user_registration POST   /users(.:format)                             devise/registrations#create
#         new_user_registration GET    /users/sign_up(.:format)                     devise/registrations#new
#        edit_user_registration GET    /users/edit(.:format)                        devise/registrations#edit
#                               PATCH  /users(.:format)                             devise/registrations#update
#                               PUT    /users(.:format)                             devise/registrations#update
#                               DELETE /users(.:format)                             devise/registrations#destroy
#                      api_base        /api                                         API::Base
#                   rails_admin        /dashboard                                   RailsAdmin::Engine
#        import_delivery_orders POST   /delivery_orders/import(.:format)            delivery_orders#import
#               delivery_orders GET    /delivery_orders(.:format)                   delivery_orders#index
#                          root GET    /                                            home#hello
#                    home_hello GET    /home/hello(.:format)                        home#hello
#
# Routes for RailsAdmin::Engine:
#   dashboard GET         /                                      rails_admin/main#dashboard
#       index GET|POST    /:model_name(.:format)                 rails_admin/main#index
#         new GET|POST    /:model_name/new(.:format)             rails_admin/main#new
#      export GET|POST    /:model_name/export(.:format)          rails_admin/main#export
# bulk_delete POST|DELETE /:model_name/bulk_delete(.:format)     rails_admin/main#bulk_delete
# bulk_action POST        /:model_name/bulk_action(.:format)     rails_admin/main#bulk_action
#        show GET         /:model_name/:id(.:format)             rails_admin/main#show
#        edit GET|PUT     /:model_name/:id/edit(.:format)        rails_admin/main#edit
#      delete GET|DELETE  /:model_name/:id/delete(.:format)      rails_admin/main#delete
# show_in_app GET         /:model_name/:id/show_in_app(.:format) rails_admin/main#show_in_app
#

# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do

  use_doorkeeper
  devise_for :users

  mount API::Base, at: "/api"
  mount RailsAdmin::Engine => '/dashboard', as: 'rails_admin'

  resources :delivery_orders, only: [:index, :import, :excelImport] do
    collection { post :import}
    collection { post :excelImport}
  end

  root to: "home#hello"
  get 'home/hello'
  get 'home/info'
  get 'home/devolutionsPage'
  get 'maps/deliveryOrders'
  get 'maps/courriersLocation'


  post 'home/ordersByCourrierName'
  post 'home/ordersByChargeNumber'
  post 'home/devolutionReasonAndObservation'
  post 'maps/oneCourrierOnly'
  post 'maps/requestedCourrierRoute'
  post 'maps/automaticCourrierRoute'

end
