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
    @news = News.find(params[:id])
  end

  def update
    @news = News.find(params[:id])
    if @news.update(news_params)
      redirect_to root_path
    else
      render "edit"
    end
  end


  private

  def news_params
    params.require(:news).permit(:body)
  end

end
