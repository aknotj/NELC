class Public::CommentsController < ApplicationController

  def create
    post = Post.find(params[:post_id])
    @comment = current_user.comments.new(comment_params)
    @comment.post_id = post.id
    if @comment.save
      redirect_to post_path(post)
    end
  end

  def destroy
    post = Post.find(params[:post_id])
    Comment.find_by(user_id: current_user, post_id: post.id).destroy
    redirect_to post_path(post)
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
