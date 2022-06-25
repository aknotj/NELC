# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  #before_action :configure_sign_in_params, only: [:create]
  prepend_before_action :check_user_status, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  def new_guest
    user = User.guest
    sign_in user
    flash[:notice] = "Signed in as a guest user"
    redirect_to home_path
  end

  protected

  def check_user_status
    user = User.find_by(email: params[:user][:email])
    if user
      if user.valid_password?(params[:user][:password]) && user.is_deactivated == true
        redirect_to new_user_registration_path
      end
    end
  end
  # If you have extra params to permit, append them to the sanitizer.
  #def configure_sign_in_params
  #  devise_parameter_sanitizer.permit(:sign_in, keys: [:email])
  #end
end
