class Public::BookmarksController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    current_user.bookmarks.create(post_id: @post.id)
    redirect_to post_path(@post)
  end

  def destroy
    @post = Post.find(params[:post_id])
    current_user.bookmarks.find_by(post_id: @post.id).destroy
    redirect_to post_path(@post)
  end

  def index
    bookmarks = current_user.bookmarks.pluck(:post_id)
    posts = Post.published.where(id: bookmarks).includes(user: {profile_image_attachment: :blob})
    @posts = Kaminari.paginate_array(posts).page(params[:page])
  end
end
