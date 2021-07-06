class Public::DiariesController < ApplicationController

  def index
    @group = Group.find(params[:group_id])
    @diaries = @group.diaries.all.page(params[:page]).per(10)
    @members = @group.group_users
  end

  def new
  end

  def show
  end

  def edit
  end

end
