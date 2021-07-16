class Public::SearchesController < ApplicationController

  before_action :authenticate_user!

  def search
    if params[:name].present?
      @false_user = User.where(is_deleted: false).pluck(:id)
      @false_owner = Group.where(owner_id: @false_user)
      @groups = @false_owner.where("name LIKE ?", "%#{params[:name]}%").includes(:users).where(users: {is_deleted: false}).order(created_at: :desc).page(params[:page]).per(10)
      @value = params[:name]

    elsif params[:name] == ""
      flash[:alert] = "検索情報が入力されていません。"
      @false_user = User.where(is_deleted: false).pluck(:id)
      @false_owner = Group.where(owner_id: @false_user)
      @groups = @false_owner.includes(:users).where(users: {is_deleted: false}).order(created_at: :desc).page(params[:page]).per(10)

    else
      @groups = Group.none
    end
  end

end
