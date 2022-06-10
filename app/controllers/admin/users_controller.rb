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
    if @user.update(is_deactivated: true)
      @user.posts.update_all(is_deleted: true)
      @user.comments.update_all(is_deleted: true)
      @user.active_relationships.destroy_all
      @user.passive_relationships.destroy_all
      @user.bookmarks.destroy_all
      @user.entries.destroy_all
      @user.messages.destroy_all
      redirect_to admin_user_path(@)
    end
  end

  private
end
