class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :confirm, :withdraw]

  def index
    @users = User.active.page(params[:page])
  end

  def show
    @user = User.find(params[:id])
    @users = @user.friends.take(5)
    @posts = @user.posts.limit(3)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user)
      flash[:notice] = "Your changes have been successfully saved!　変更が保存されました"
    else
      render :edit
    end
  end

  def posts
    @user = User.find(params[:id])
    @posts = @user.posts.published.page(params[:page])
    @categories = Category.tagged_by(@user).order_by_posts
  end

  def confirm
    @user = current_user
  end

  def withdraw
    current_user.deactivate
    reset_session
    redirect_to root_path
    flash[:notice] = "Your account has been successfully deleted! アカウントが削除されました"
  end

  def welcome
    @user = current_user
  end

  private

  def user_params
    params.require(:user).permit(:name, :name_jap, :gender, :native_language, :learning_language, :introduction, :profile_image, :time_zone)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(@user)
    end
  end

end
