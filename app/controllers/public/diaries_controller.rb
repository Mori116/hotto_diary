class Public::DiariesController < ApplicationController

  def index
    @group = Group.find(params[:group_id])
    @diaries = @group.diaries.all.page(params[:page]).per(10)
    @members = @group.group_users
  end

  def new
    @diary = Diary.new
  end

  def create
    @group = Group.find(params[:group_id])
    @diary = Diary.new(diary_params)
    @diary.user_id = current_user.id
    @diary.group_id = Group.find(params[:group_id]).id
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
    @diary = Diary.find(params[:id])
  end

  def update
    @diary = Diary.find(params[:id])
    if @diary.update(diary_params)
      redirect_to group_diary_path(@diary)
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
