class Admin::CommentsController < ApplicationController
  before_action :authenticate_admin!
  
  def show
    @comment = Comment.find(params[:id])
    @post = @comment.post
    @comments = @post.comments.page(params[:page]).includes(:post, user: {profile_image_attachment: :blob})
  end

  def update
    @comment = Comment.find(params[:id])
    @comment.update(comment_params)
    redirect_to admin_post_comment_path(@comment)
    flash[:notice] = "The comment status has been successfully updated"
  end


  private

  def comment_params
    params.require(:comment).permit(:is_deleted)
  end
end
