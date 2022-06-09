class Admin::CommentsController < ApplicationController
  def index
    @post = Post.find(params[:post_id])
    @comments = @post.comments.all
  end

  def show
    @comment = Comment.find(params[:id])
    @post = @comment.post
  end

  def update
    @comment = Comment.find(params[:id])
    @comment.update(comment_params)
    redirect_to admin_post_comment_path(@comment)
  end


  private

  def comment_params
    params.require(:comment).permit(:is_deleted)
  end
end
