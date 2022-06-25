class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!
  
  def index
    @posts = Post.page(params[:page]).includes(user: {profile_image_attachment: :blob})
  end

  def show
    @post = Post.find(params[:id])
    @comments = @post.comments.page(params[:page]).includes(:post, user: {profile_image_attachment: :blob})
  end

  def update
    @post = Post.find(params[:id])
    @post.update(post_params)
    redirect_to admin_post_path(@post)
    flash[:notice] = "The post status has been successfully updated"
  end

  private

  def post_params
    params.require(:post).permit(:is_deleted)
  end
end
