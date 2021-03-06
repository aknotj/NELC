class Public::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.new(post_params)
    categories = params[:post][:name].split(/,|、/) #半角、全角カンマで区切る
    if @post.save
      @post.save_categories(categories)
      if params[:post][:is_published] == "true"
        redirect_to post_path(@post)
        flash[:notice] = "Your post has been successfully published. 投稿しました"
      elsif params[:post][:is_published] == "false"
        redirect_to posts_drafts_path
        flash[:notice] = "Your post has been saved as draft. 下書きを保存しました"
      end
    else
      @post.save_categories(categories)
      @categories = params[:post][:name].split(/,|、/)
      render :new
    end
  end

  def edit
    @post = Post.find(params[:id])
    @categories = @post.categories.pluck(:name).join(",") #登録済みカテゴリーをform valueに表示
  end

  def update
    @post = Post.find(params[:id])
    categories = params[:post][:name].split(/,|、/)
    if  @post.update(post_params)
      @post.save_categories(categories)
      if params[:post][:is_published] == "true"
        redirect_to post_path(@post)
        flash[:notice] = "Your post has been successfully published. 投稿しました"
      elsif params[:post][:is_published] == "false"
        redirect_to posts_drafts_path
        flash[:notice] = "Your post has been saved as draft. 下書きを保存しました"
      end
    else
      @categories = @post.categories.pluck(:name).join(',')
      render :edit
    end
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
    @comments = @post.comments.valid.includes(:post, user: {profile_image_attachment: :blob})
    @user = @post.user
    @latest_posts = @user.posts.published.limit(4)
    @categories = Category.tagged_by(@user).includes(:posts).order_by_posts.limit(10)
  end

  def drafts
    @posts = current_user.posts.draft.page(params[:page])
    @latest_posts = current_user.posts.published.limit(4)
    @categories = Category.tagged_by(current_user).includes(:posts).order_by_posts
  end

  def index
    @posts = Post.published.includes(user: {profile_image_attachment: :blob}).page(params[:page])
    @categories = Category.includes(:posts).order_by_posts.limit(10)
  end

  def by_category
    @category = Category.find(params[:category_id])
    @posts = @category.posts.published.includes(user: {profile_image_attachment: :blob}).page(params[:page])
    @latest_posts = Post.published.limit(4)
    @categories = Category.includes(:posts).order_by_posts.limit(10)
  end

  def destroy
    @post.categories.delete
    @post = Post.find(params[:id])
    if @post.destroy
      Report.where(post_id: @post.id).destroy_all
    end
    redirect_to user_posts_path(@post.user)
    flash[:notice] = "Your post has been successfully deleted. 投稿を削除しました"
  end


  protected

  def ensure_correct_user
    @post = Post.find(params[:id])
    unless @post.user == current_user
      redirect_to post_path(@post)
    end
  end

  def post_params
    params.require(:post).permit(:title, :body, :language, :is_published)
  end
end
