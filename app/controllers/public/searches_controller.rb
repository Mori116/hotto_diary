class Public::SearchesController < ApplicationController

  before_action :authenticate_user!

  def search
    if params[:name].present?
      @false_user = User.not_deleted.pluck(:id)
      @false_owner = Group.where(owner_id: @false_user)
      @groups = @false_owner.where("name LIKE ?", "%#{params[:name]}%").user_order_desc_per_10(params[:page])
      @value = params[:name]

    elsif params[:name] == ""
      flash[:alert] = "検索情報が入力されていません。"
      @false_user = User.not_deleted.pluck(:id)
      @false_owner = Group.where(owner_id: @false_user)
      @groups = @false_owner.user_order_desc_per_10(params[:page])

    else
      @groups = Group.none
    end
  end

end
