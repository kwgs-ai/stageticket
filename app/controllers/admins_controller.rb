class AdminsController < ApplicationController
  before_action :admin_login_required, only: [:index,:show]

  def index

  end

  def show
    @admin = current_admin
  end

  def edit
    @admin = current_admin
  end

  def update
    @admin = current_admin
    @admin.assign_attributes(params[:admin])
    if @admin.save
      redirect_to :admin, notice: '会員情報を更新しました。'
    else
      render 'edit'
    end
  end


  def admin_false_stages
    @link = 'admin_stage_show_stage'
    @stages = Stage.where(status: 1).where('date >= ?', Date.today)
                .page(params[:page]).per(3)
    @after = Stage.where(status: 1).where('date < ?', Date.today)
                  .page(params[:page]).per(3)
  end

  def admin_true_stages
    @stages = Stage.where(status: [2,3]).where('date >= ?', Date.today)
                   .page(params[:page]).per(3)
    @after = Stage.where(status: [2,3]).where('date < ?', Date.today)
                  .page(params[:page]).per(3)
    @link = 'stage'
  end

end
