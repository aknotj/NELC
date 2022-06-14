class Public::SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @model = params[:model]
    @language = params[:language]
    @name = params[:name]
    @gender = params[:gender]
    @content = params[:content]
    if @model == "Users"
      @records = User.search_for(@language, @name, @gender).page(params[:page])
    elsif @model == "Posts"
      @records = Post.search_for(@language, @content).page(params[:page])
    end
  end
end
