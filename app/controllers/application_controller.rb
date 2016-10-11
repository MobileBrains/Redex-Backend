class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  #must by velow protect_from_fergery
  before_action :authenticate_user!


end
