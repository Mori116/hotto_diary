class Admin::UsersController < ApplicationController

  def index
    @users = User.all.order(created_at: :desc).page(params[:page]).per(10)
  end

  def show
  end

  def edit
  end

end
