class Admin::GroupsController < ApplicationController

  before_action :authenticate_admin!

  def index
    @groups = Group.all.order(created_at: :desc).page(params[:page]).per(10)
  end

  def diaries
    @diaries = Diary.all.order(created_at: :desc).page(params[:page]).per(10)
  end
  # 全日記一覧画面

  def show
    @group = Group.find(params[:id])
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    redirect_to admin_groups_path
  end

end
