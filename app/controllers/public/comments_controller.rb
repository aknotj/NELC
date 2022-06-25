class Public::CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:destroy]

  def create
    @post = Post.find(params[:post_id])
    @comment = current_user.comments.new(comment_params)
    @comment.post_id = @post.id
    if @comment.save
      @comment.post.create_notification_comment(current_user, @comment.id)
      @comments = @post.comments.includes(post: {user: {profile_image_attachment: :blob}})
      render "comments"
    else
      render "error"
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    @comment = Comment.find(params[:id])
    @comment.destroy
    @comments = @post.comments.includes(post: {user: {profile_image_attachment: :blob}})
    render "comments"
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def ensure_correct_user
    post = Post.find(params[:post_id])
    comment = Comment.find_by(post_id: post.id, id: params[:id])
    unless post.user == current_user || comment.user == current_user
      redirect_to post_path(post)
    end
  end
end
