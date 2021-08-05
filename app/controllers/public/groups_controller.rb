class Public::GroupsController < ApplicationController

  before_action :authenticate_user!

  def index
    false_user = User.not_deleted.pluck(:id)
    false_owner = Group.where(owner_id: false_user)
    @groups = false_owner.includes(:users).where(users: {is_deleted: false}).order_desc_per_10(params[:page])
    # 有効ステータスのグループ作成者のグループのみ表示させる
  end

  def new
    @group = Group.new
  end

  def create
    group = Group.new(group_params)
    group.owner_id = current_user.id
    group.users << current_user
    if group.save
      redirect_to group_path(group)
    else
      render "new"
    end
  end

  def show
    @group = Group.find(params[:id])
    owner_id = @group.owner_id
    @user = User.find(owner_id)
    @count_users = @group.users.where(is_deleted: false).size
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    group = Group.find(params[:id])
    if group.owner_id == current_user.id
      if group.update(group_params)
        redirect_to group_path(group)
      else
        render "edit"
      end
    else
      redirect_to groups_path
    end
  end

  def join
    @group = Group.find(params[:id])
  end
  # グループ参加パスワードの画面表示

  def join_create
    group = Group.find(params[:id])
    if group && group.authenticate(params[:group][:password])
      group.users << current_user
      # passwordが合っていたらグループにcurrent_userが追加される
      redirect_to group_diaries_path(group)
    else
      flash[:alert] = "パスワードが正しくありません。"
      render "join"
    end
  end
  # グループに参加する処理

  def exit
    group = Group.find(params[:id])
    group.users.delete(current_user)
    redirect_to group_path(group)
  end
  # グループから抜ける処理

  def destroy
    group = Group.find(params[:id])
    if group.owner_id == current_user.id
      group.destroy
      redirect_to groups_path
    else
      redirect_to groups_path
    end
  end


  private

  def group_params
    params.require(:group).permit(:name, :image, :password, :password_confirmation)
  end
end
