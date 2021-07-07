class Public::DiaryCommentsController < ApplicationController

  def create
    @diary = Diary.find(params[:diary_id])
    @comment_new = current_user.diary_comments.new(diary_comment_params)
    @comment_new.diary_id = @diary.id
    if @comment_new.save
      redirect_to request.referer
    else
      render "show"
    end
  end

  def destroy
    @diary = Diary.find(params[:diary_id])
    @comment = DiaryComment.find_by(id: params[:id], diary_id: @diary.id)
    @comment.destroy
  end


  private

  def diary_comment_params
    params.require(:diary_comment).permit(:comment)
  end

end
