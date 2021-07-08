class Admin::GroupsController < ApplicationController

  def index
    @groups = Group.all.order(created_at: :desc).page(params[:page]).per(10)
  end

  def show
    @group = Group.find(params[:id])
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])
    if @group.update(group_params)
      redirect_to admin_group_path(@group)
    else
      render "edit"
    end
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    redirect_to admin_groups_path
  end

  private

  def group_params
    params.requre(:group).permit(:name, :image)
  end

end
