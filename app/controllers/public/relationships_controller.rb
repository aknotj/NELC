class Public::RelationshipsController < ApplicationController

  def create
    user = User.find(params[:user_id])
    current_user.follow(user)
    redirect_to user_path(user)
  end

  def destroy
    user = User.find(params[:user_id])
    current_user.unfollow(user)
    redirect_to user_path(user)
  end
  
  def friends
    @user = User.find(params[:user_id])
    @users = @user.friends
  end
  
  def following
    @user = User.find(params[:user_id])
    @users = @user.followings
  end
  
  def followers
    @user = User.find(params[:user_id])
    @users = @user.followers
  end
  
end
