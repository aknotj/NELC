class Public::HomeController < ApplicationController
  def top
  end

  def home
     @posts = Post.published.where(user_id: [current_user.id, *current_user.following_ids]).page(params[:page])
  end
end
