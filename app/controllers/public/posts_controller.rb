class Public::PostsController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update, :destroy, :drafts]

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.new(post_params)
    categories = params[:post][:name].split(/,|、/) #半角、全角カンマで区切る
    if @post.save
      @post.save_categories(categories)
      redirect_to post_path(@post)
    else
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
      redirect_to post_path(@post)
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def drafts
  end

  def index
    @posts = Post.page(params[:page])
  end

  def by_category
  end

  def destroy
  end


  protected

  def ensure_correct_user
    @post = Post.find(params[:id])
    unless @post.user == current_user
      redirect_to post_path(@post)
    end
  end

  def post_params
    params.require(:post).permit(:title, :body, :language)
  end
end
