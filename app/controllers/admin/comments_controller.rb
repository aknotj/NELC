class Admin::CommentsController < ApplicationController
  def show
    @comment = Comment.find(params[:id])
    @post = @comment.post
    @comments = @post.comments.page(params[:page])
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
