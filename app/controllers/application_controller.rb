class ApplicationController < ActionController::Base  #INHERIT from class Base, in the Rails GEM
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
end
