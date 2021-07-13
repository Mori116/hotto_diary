class Public::DiariesController < ApplicationController

  before_action :authenticate_user!

  def index
    @group = Group.find(params[:group_id])
    @diaries = @group.diaries.user_order_desc_per_10(params[:page])
    @members = @group.group_users
  end

  def new
    @diary = Diary.new
  end

  def create
    @group = Group.find(params[:group_id])
    @diary = Diary.new(diary_params)
    @diary.user_id = current_user.id
    @diary.group_id = @group.id
    if @diary.save
      redirect_to group_diary_path(@group.id, @diary.id)
    else
      render "new"
    end
  end

  def show
    @group = Group.find(params[:group_id])
    @diary = Diary.find(params[:id])
    @comment_new = DiaryComment.new
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
      redirect_to group_diary_path(@group.id, @diary.id)
    else
      render "edit"
    end
  end

  def destroy
    @group = Group.find(params[:group_id])
    @diary = Diary.find(params[:id])
    @diary.destroy
    redirect_to group_diaries_path
  end

  private

  def diary_params
    params.require(:diary).permit(:title, :body, :image, :status)
  end

end
