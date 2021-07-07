class Public::GroupsController < ApplicationController

  def index
    @groups = Group.all.order(created_at: :desc).page(params[:page]).per(10)
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.owner_id = current_user.id
    @group.users << current_user
    if @group.save
      redirect_to group_path(@group)
    else
      render "new"
    end
  end

  def show
    @group = Group.find(params[:id])
    @owner_nickname = User.find(@group.owner_id).nickname
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])
    if @group.update(group_params)
      redirect_to group_path(@group)
    else
      render "edit"
    end
  end

  def join_groups
    @user = User.find(current_user.id).group_ids
    @groups = Group.find(@user)
  end
  # 所属グループの表示

  def join
    @group = Group.find(params[:id])
  end
  # グループ参加パスワードの画面表示

  def join_create
    @group = Group.find(params[:id])
    if @group && @group.authenticate(params[:password])
      @group.users << current_user
      # passwordが合っていたらグループにcurrent_userが追加される
      redirect_to group_diaries_path
    else
      render "join"
    end
  end
  # グループに参加する処理

  def exit
    @group = Group.find(params[:id])
    @group.users.delete(current_user)
    redirect_to group_path(@group)
  end
  # グループから抜ける処理

  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    redirect_to groups_path
  end


  private

  def group_params
    params.require(:group).permit(:name, :image, :password, :password_confirmation)
  end
end
