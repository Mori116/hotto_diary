class Admin::GroupsController < ApplicationController

  before_action :authenticate_admin!

  def index
    @groups = Group.all.order_desc_per_10(params[:id])
  end

  def diaries
    @diaries = Diary.all.order_desc_per_10(params[:id])
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
