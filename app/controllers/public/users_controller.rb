class Public::UsersController < ApplicationController

  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
    @notifications = current_user.passive_notifications.order(created_at: :desc).page(params[:page]).per(10)
    # current_userの投稿に紐づいた通知一覧
    @notifications.where(checked: false).each do |notification|
      notification.update_attributes(checked: true)
    end
    # @notificationの中でまだ確認していない(showに一度も遷移していない)通知のみ
  end

  def join_groups
    @false_user = User.where(is_deleted: false).pluck(:id)
    @false_owner = Group.where(owner_id: @false_user)
    @groups = @false_owner.includes(:group_users).where(group_users: {user_id: current_user.id}).includes(:users).where(users: {is_deleted: false})
    # 有効ステータスのグループ作成者のグループ、ユーザのみ表示させる
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
    flash[:alert] = "退会しました。ご利用ありがとうございました！"
    redirect_to root_path
  end


  private

  def user_params
    params.require(:user).permit(:last_name, :first_name, :last_name_kana, :first_name_kana, :nickname, :email, :is_deleted)
  end

end
