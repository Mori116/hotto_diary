class Public::DiaryCommentsController < ApplicationController

  before_action :authenticate_user!

  def create
    @group = Group.find(params[:group_id])
    @diary = Diary.find(params[:diary_id])
    @comment_new = current_user.diary_comments.new(diary_comment_params)
    @comment_new.diary_id = @diary.id
    if @comment_new.save
      @comment_new.create_notification_comment!(current_user, @comment_new.id, @diary.user_id)
    else
      render "error"
    end
    @diary_comments = @diary.diary_comments
    # コメント全体を置き換えるような動作のため、createアクションでも本コードの記述が必要
  end

  def destroy
    @group = Group.find(params[:group_id])
    @diary = Diary.find(params[:diary_id])
    @diary_comments = @diary.diary_comments
    comment = DiaryComment.find_by(id: params[:id], diary_id: @diary.id)
    comment.destroy
  end


  private

  def diary_comment_params
    params.require(:diary_comment).permit(:comment)
  end

end
