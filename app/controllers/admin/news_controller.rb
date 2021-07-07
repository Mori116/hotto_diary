class Admin::NewsController < ApplicationController

  def new
    @news = News.new
  end

  def create
    @news = News.new(news_params)
    if @news.save
      redirect_to root_path
    else
      render "new"
    end
  end

  def edit
  end


  private

  def news_params
    params.require(:news).permit(:body)
  end

end
