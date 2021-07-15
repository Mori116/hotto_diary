class Public::HomesController < ApplicationController

  def top
    @news = News.all.order(created_at: :desc).page(params[:page]).per(5)
  end

  def about
  end

end
