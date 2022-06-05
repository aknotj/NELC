class Public::UsersController < ApplicationController
  def index
  end

  def show
    @user = User.find(params[:id])
    @users = User.all.limit(5) #Reminder: change User.all to @user.friends
    @posts = @user.posts.limit(3)
  end

  def edit
  end

  def update
  end

  def posts
    @user = User.find(params[:id])
    @posts = @user.posts
  end
end
