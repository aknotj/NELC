class Public::UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @users = @user.friends.take(5)
    @posts = @user.posts.limit(3)
    if @user.is_friend_with?(current_user)
      rooms = current_user.entries.pluck(:room_id)
      entries = Entry.find_by(user_id: @user.id, room_id: rooms)
      unless entries.nil?
        @room = entries.room
      end
    end
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
