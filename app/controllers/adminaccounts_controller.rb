class AdminaccountsController < ApplicationController
  before_action :admin_login_required, only: [:index]

  def index
    @stages = Stage.where(status: false)
  end

  def show
    @admin = current_admin
  end

  def edit
    @admin = Adminaccount.find(params[:id])
  end

  def update
    @admin = Adminaccount.find(params[:id])
    @admin.assign_attributes(params[:adminaccount])
    if @admin.save
      redirect_to @admin, notice: "会員情報を更新しました。"
    else
      render "edit"
    end
  end

  def destroy
    @admin = Adminaccount.find(params[:id])
    @admin.destroy
    redirect_to :root, notice: "会員を削除しました。"

  end

  def admin_false_stages
    @stages = Stage.where(status: false)
  end

  def admin_true_stages
    @stages = Stage.where(status: true)
  end
end
