class Admin::UsersController < ApplicationController
  def index
    @users = User.page(params[:page])
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.page(params[:page]).per(6)
  end

  def update
    @user = User.find(params[:id])
    @user.update(is_deactivated: false)
    redirect_to admin_user_path(@user)
  end

  def confirm
    @user = User.find(params[:id])
  end

  def deactivate
    @user = User.find(params[:id])
    @user.deactivate
    redirect_to admin_user_path(@user)
  end

  private
end
