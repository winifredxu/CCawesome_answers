class ApplicationController < ActionController::Base  #INHERIT from class Base, in the Rails GEM
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # to allow for first/last_name fields in sign-up and acct-update
  before_action :configure_devise_params, if: :devise_controller?

  private
  def configure_devise_params
  	devise_parameter_sanitizer.for(:sign_up) << [:first_name, :last_name]
  	devise_parameter_sanitizer.for(:account_update) << [:first_name, :last_name]  	
  end
end
