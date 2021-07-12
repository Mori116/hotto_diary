class Admin::DiariesController < ApplicationController

  before_action :authenticate_admin!

  def index
    @group = Group.find(params[:group_id])
    @diaries = @group.diaries.all.order(created_at: :desc).page(params[:page]).per(10)
    @members = @group.group_users
  end

  def show
    @group = Group.find(params[:group_id])
    @diary = Diary.find(params[:id])
    @diary_comments = @diary.diary_comments
  end

end
