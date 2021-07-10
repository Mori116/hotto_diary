class Public::UsersController < ApplicationController

  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
    # ここに通知の変数記述する
  end

  def join_groups
    @user = User.find(params[:id]).group_ids
    @groups = Group.find(@user)
  end
  # 所属グループの表示

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user)
    else
      render "edit"
    end
  end

  def quit
    @user = User.find(params[:id])
  end

  def withdraw
    @user = User.find(current_user.id)
    @user.update(is_deleted: true)
    # ユーザステータスを有効から退会にする
    reset_session
    # すべてのセッション情報を削除
    redirect_to root_path
  end


  private

  def user_params
    params.require(:user).permit(:last_name, :first_name, :last_name_kana, :first_name_kana, :nickname, :email, :is_deleted)
  end

end
