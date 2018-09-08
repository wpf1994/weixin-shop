class ApplicationController < ActionController::Base
  include TextToolsModule
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  skip_before_filter :verify_authenticity_token

  before_action :configure_permitted_parameters, if: :devise_controller?
  # before_action :authenticate_user!#, unless: [:other_controller]

  def other_controller
    true
  end

  # def after_sign_in_path_for(resource)
  #
  #
  # end
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:phone, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :phone, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:phone, :email, :password, :password_confirmation, :current_password) }
  end
end
