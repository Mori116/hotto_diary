class Public::SearchesController < ApplicationController

  def search
    if params[:name].present?
      @groups = Group.where("name LIKE ?", "%#{params[:name]}%").page(params[:page]).per(10)
      @value = params[:name]
    elsif params[:name] == ""
      flash[:alert] = "検索情報が入力されていません。"
      @groups = Group.all.page(params[:page]).per(10)
    else
      @groups = Group.none
    end
  end

end
