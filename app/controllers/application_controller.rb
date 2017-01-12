class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  #must by velow protect_from_forgery
  before_action :authenticate_user!

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to main_app.root_url, :alert => exception.message
  end
end
