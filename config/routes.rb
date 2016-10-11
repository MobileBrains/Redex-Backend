Rails.application.routes.draw do
  get 'home/hello'

  mount RailsAdmin::Engine => '/dashboard', as: 'rails_admin'
  devise_for :users
  devise_for :installs
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    root to: "home#hello"
end
