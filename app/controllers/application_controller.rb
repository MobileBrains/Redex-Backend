class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  #must by velow protect_from_forgery
  before_action :authenticate_user!

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name,:document,:phone,:email,:role,:password,:password_confirmation,:client_id])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name,:document,:phone,:email,:role,:password,:password_confirmation,:client_id])

  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to main_app.root_url, :alert => exception.message
  end
end
