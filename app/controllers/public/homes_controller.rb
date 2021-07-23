class Public::HomesController < ApplicationController

  def top
    @news = News.all
  end

  def about
  end

end
