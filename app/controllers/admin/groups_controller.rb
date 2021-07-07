class Admin::GroupsController < ApplicationController

  def index
    @groups = Group.all.order(created_at: :desc).page(params[:page]).per(10)
  end

  def show
    @group = Group.find(params[:id])
  end

  def edit
  end

end
