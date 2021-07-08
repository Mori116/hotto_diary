class Admin::DiaryCommentsController < ApplicationController

  def destroy
    @group = Group.find(params[:group_id])
    @diary = Diary.find(params[:diary_id])
    @comment = DiaryComment.find_by(id: params[:id], diary_id: @diary.id)
    @comment.destroy
    redirect_to request.referer
  end

end
