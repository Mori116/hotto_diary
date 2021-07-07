class Admin::UsersController < ApplicationController

  def index
    @users = User.all.order(created_at: :desc).page(params[:page]).per(10)
  end

  def show
    @user = User.find(params[:id])
  end

  def join_groups
    @user = User.find(params[:id]).group_ids
    @groups = Group.find(@user)
  end
  # 所属グループの表示

  def edit
  end

end
