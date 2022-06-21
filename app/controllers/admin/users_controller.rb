class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @users = User.page(params[:page])
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.includes(user: {profile_image_attachment: :blob}).page(params[:page]).per(6)
  end

  def update
    @user = User.find(params[:id])
    @user.update(is_deactivated: false)
    redirect_to admin_user_path(@user)
    flash[:notice] = "The user status has been successfully updated"
  end

  def confirm
    @user = User.find(params[:id])
  end

  def deactivate
    @user = User.find(params[:id])
    @user.deactivate
    redirect_to admin_user_path(@user)
    flash[:notice] = "The user has been deactivated"
  end

  private
end
