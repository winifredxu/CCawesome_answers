class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def twitter
    # request's available scope in the controllers
    omniauth_data = request.env["omniauth.auth"].to_hash
    user = User.find_or_create_from_twitter(omniauth_data)

    if user
      sign_in user
      redirect_to root_path, notice: "Welcome, #{user.first_name}."
    else
      redirect_to root_path, alert: "Sorry! Contact us if problem persists."

    end
    
    # to see the actual omniauth_data sent from the provider:
    #render text: omniauth_data
    #render json: omniauth_data
  end

end