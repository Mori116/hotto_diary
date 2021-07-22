class Admin::DiariesController < ApplicationController

  before_action :authenticate_admin!

  def index
    @group = Group.find(params[:group_id])
    @diaries = @group.diaries.order_desc_per_10(params[:page])
    @members = @group.group_users
  end

  def show
    @group = Group.find(params[:group_id])
    @diary = Diary.find(params[:id])
    @diary_comments = @diary.diary_comments
  end

  def destroy
    @group = Group.find(params[:group_id])
    @diary = Diary.find(params[:id])
    @diary.destroy
    redirect_to admin_group_diaries_path
  end

end
