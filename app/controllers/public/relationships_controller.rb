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
    friends_ids = @user.friends.pluck(:id)
    @users = User.where(id: friends_ids).includes(:following, :followers, profile_image_attachment: :blob)
  end

  def following
    @user = User.find(params[:user_id])
    following_ids = @user.following.pluck(:id)
    @users = User.where(id: following_ids).includes(:following, :followers, profile_image_attachment: :blob)
  end

  def followers
    @user = User.find(params[:user_id])
    @users = @user.followers
    followers_ids = @user.followers.pluck(:id)
    @users = User.where(id: followers_ids).includes(:following, :followers, profile_image_attachment: :blob)
  end

end
