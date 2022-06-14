class Public::BookmarksController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    current_user.bookmarks.create(post_id: @post.id)
    render "bookmark"
  end

  def destroy
    @post = Post.find(params[:post_id])
    current_user.bookmarks.find_by(post_id: @post.id).destroy
    render "bookmark"
  end

  def index
    bookmarks = current_user.bookmarks.pluck(:post_id)
    posts = Post.find(bookmarks)
    @posts = Kaminari.paginate_array(posts).page(params[:page])
  end

  def ensure_post_visibility
    post = Post.find(params[:post_id])
    unless post.is_deleted == false
      redirect_to bookmarks_path
    end
  end

end
