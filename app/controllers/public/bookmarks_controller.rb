class Public::BookmarksController < ApplicationController

  def create
    @post = Post.find(params[:post_id])
    current_user.bookmarks.create(post_id: @post.id)
    redirect_to request.referer
  end

  def destroy
    @post = Post.find(params[:post_id])
    current_user.bookmarks.find_by(post_id: @post.id).destroy
    redirect_to request.referer
  end

  def index
    bookmarks = current_user.bookmarks.pluck(:post_id)
    posts = Post.find(bookmarks)
    @posts = Kaminari.paginate_array(posts).page(params[:page])
  end
end
