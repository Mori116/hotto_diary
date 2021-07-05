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
  end

  def edit
  end

  def join_groups
  end

  def join
  end


  private

  def group_params
    params.require(:group).permit(:name, :image, :password, :password_confirmation)
  end
end
