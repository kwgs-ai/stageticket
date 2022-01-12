class UsersController < ApplicationController
  before_action :user_login_required, only: [:index, :show]

  def new
    if cookies.signed[:actor_id].nil? && cookies.signed[:user_id].nil? && cookies.signed[:admin_id].nil?
      @user = User.new
    else
      redirect_to :root, notice: 'すでにログイン中です'
      end
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      cookies.signed[:user_id] = @user.id
      redirect_to :root, notice: '登録しました'
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.assign_attributes(params[:user])
    if @user.save
      redirect_to @user, notice: '会員情報を更新しました。'
    else
      render 'edit'
    end
  end

  def show
    @user = current_user
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    cookies.delete(:user_id)
    redirect_to :root, notice: '会員を削除しました。'
  end
end
