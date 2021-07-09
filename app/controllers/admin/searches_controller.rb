class Admin::SearchesController < ApplicationController

  def search
    @how = params["search"]["how"]
    @model = params["search"]["model"]
    @value = params["search"]["value"]
    @datas = search_for(@how, @model, @value).order(created_at: :desc).page(params[:page]).per(10)
  end


  private

  def search_for(how, model, value)
    case how
      when 'match'
        match(model, value)
      when 'partical'
        partical(model, value)
    end
  end
  # 検索方法の確認

  def match(model, value)
    if model == 'user'
      User.where(nickname: value)
    elsif model == 'group'
      Group.where(name: value)
    else
      Diary.where(title: value)
    end
  end
  # 完全一致

  def partical(model, value)
    if model == 'user'
      User.where("nickname LIKE ?", "%#{value}%")
    elsif model == 'group'
      Group.where("name LIKE ?", "%#{value}%")
    else
      Diary.where("title LIKE ?", "%#{value}%")
    end
  end
  # 部分一致

end
