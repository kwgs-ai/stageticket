class UseraccountsController < ApplicationController
  before_action :user_login_required, only: [:index]
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

  end
  def update

  end
  def show
    @user = current_user
  end
end
