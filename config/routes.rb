# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  use_doorkeeper
  root to: "home#hello"
  get 'home/hello'

  mount API::Base, at: "/api"
  mount RailsAdmin::Engine => '/dashboard', as: 'rails_admin'

  devise_for :users
end
