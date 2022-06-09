class Public::SearchesController < ApplicationController

  def search
    @model = params[:model]
    @language = params[:language]
    @name = params[:name]
    @gender = params[:gender]
    @content = params[:content]
    if @model == "Users"
      @records = User.search_for(@language, @name, @gender, @content)
    elsif @model == "Posts"
      @records = Post.search_for(@language, @content)
    end
  end
end
