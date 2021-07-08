class Admin::DiariesController < ApplicationController

  def index
    @group = Group.find(params[:group_id])
    @diaries = Diary.all.order(created_at: :desc).page(params[:page]).per(10)
    @members = @group.group_users
  end

  def show
    @diary = Diary.find(params[:id])
    @diary_comments = @diary.diary_comments
  end

  def edit
  end

end
