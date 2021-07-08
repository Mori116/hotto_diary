class Admin::DiariesController < ApplicationController

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

  def edit
    @group = Group.find(params[:group_id])
    @diary = Diary.find(params[:id])
  end

  def update
    @group = Group.find(params[:group_id])
    @diary = Diary.find(params[:id])
    if @diary.update(diary_params)
      redirect_to admin_group_diary_path(@group.id, @diary.id)
    else
      render "edit"
    end
  end

  def destroy
    @group = Group.find(params[:group_id])
    @diary = Diary.find(params[:id])
    @diary.destroy
    redirect_to admin_group_diaries_path
  end


  private

  def diary_params
    params.require(:diary).permit(:title, :body, :image, :status)
  end

end
