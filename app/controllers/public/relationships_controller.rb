class Public::RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    @user = User.find(params[:user_id])
    current_user.follow(@user)
    @user.create_notification_follow(current_user)
    render "follow"
  end

  def destroy
    @user = User.find(params[:user_id])
    current_user.unfollow(@user)
    render "follow"
  end

  def friends
    @user = User.find(params[:user_id])
    @users = @user.friends
  end

  def following
    @user = User.find(params[:user_id])
    @users = @user.following
  end

  def followers
    @user = User.find(params[:user_id])
    @users = @user.followers
  end

end
