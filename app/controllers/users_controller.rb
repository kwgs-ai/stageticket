class UsersController < ApplicationController
  before_action :user_login_required, only: [:index,:show]

  def index

  end

  def new
    @user = Useraccount.new
  end

  def create
    @user = Useraccount.new(params[:useraccount])
    if @user.save
      redirect_to :root, notice: "登録しました"
    else
      render "new"
    end
  end

  def edit
    @user = Useraccount.find(params[:id])
  end

  def update
    @user = Useraccount.find(params[:id])
    @user.assign_attributes(params[:useraccount])
    if @user.save
      redirect_to @user, notice: "会員情報を更新しました。"
    else
      render "edit"
    end

  end

  def show
    @user = current_user
  end

  def destroy
    @user = Useraccount.find(params[:id])
    @user.destroy
    redirect_to :root, notice: "会員を削除しました。"

  end
end
