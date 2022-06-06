class Public::UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @users = User.all.limit(5) #Reminder: change User.all to @user.friends
    @posts = @user.posts.limit(3)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user)
    end
  end

  def posts
    @user = User.find(params[:id])
    @posts = @user.posts.page(params[:page])
  end

  private

  def user_params
    params.require(:user).permit(:name, :name_jap, :gender, :native_language, :learning_language, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(@user)
    end
  end

end
