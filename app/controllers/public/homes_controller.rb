class Public::HomesController < ApplicationController

  def top
    @news = News.all.page(params[:page]).per(5)
  end

  def about
  end

end
