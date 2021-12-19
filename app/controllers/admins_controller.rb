class AdminsController < ApplicationController
  before_action :admin_login_required, only: [:index,:show]

  def index

  end

  def show
    @admin = current_admin
  end

  def edit
    @admin = Admin.find(params[:id])
  end

  def update
    @admin = Admin.find(params[:id])
    @admin.assign_attributes(params[:admin])
    if @admin.save
      redirect_to :admin, notice: '会員情報を更新しました。'
    else
      render 'edit'
    end
  end

  def destroy
    @admin = Admin.find(params[:id])
    @admin.destroy
    redirect_to :root, notice: '会員を削除しました。'

  end

  def admin_false_stages
    @link = 'admin_stage_show_stage'
    @stages = Stage.where(status: 1)
  end

  def admin_true_stages
    @stages = Stage.where(status: 2)
    @link = 'stage'
  end

end
