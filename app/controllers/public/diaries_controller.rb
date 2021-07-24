class Public::DiariesController < ApplicationController

  before_action :authenticate_user!

  def index
    @group = Group.find(params[:group_id])
    @diaries = @group.diaries.user_order_desc_per_10(params[:page])
    @members = @group.group_users.joins(:user).where(users: {is_deleted: false})
    # 有効ステータスのユーザの日記のみ表示させる
    @group_owner = @group.owner
    # グループ作成者のステータス確認、ビューにて条件分岐
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
      redirect_to group_diary_path(@group, @diary)
    else
      render "new"
    end
  end

  def show
    @group = Group.find(params[:group_id])
    @diary = Diary.find(params[:id])
    @group_owner = @group.owner
    # グループ作成者のステータス確認、ビューにて条件分岐
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
    if @diary.user_id == current_user.id
      if @diary.update(diary_params)
        redirect_to group_diary_path(@group, @diary)
      else
        render "edit"
      end
    else
      redirect_to group_diaries_path(@group)
    end
  end

  def destroy
    @group = Group.find(params[:group_id])
    @diary = Diary.find(params[:id])
    if @diary.user_id == current_user.id
      @diary.destroy
      redirect_to group_diaries_path(@group)
    else
      redirect_to group_diaries_path(@group)
    end
  end

  private

  def diary_params
    params.require(:diary).permit(:title, :body, :image, :status)
  end

end
