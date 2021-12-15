class ActoraccountsController < ApplicationController
  before_action :actor_login_required, only: [:index]

  def index
    @actor = Actoraccount.new
  end

  def show
    @actor = current_actor
  end

  def new
    @actor = Actoraccount.new
  end

  def create
    @actor = Actoraccount.new(params[:actoraccount])
    if @actor.save
      redirect_to :root, notice: "登録しました"
    else
      render "new"
    end
  end

  def edit
    @actor = Actoraccount.find(params[:id])
  end

  def update
    @actor = Actoraccount.find(params[:id])
    @actor.assign_attributes(params[:actoraccount])
    if @actor.save
      redirect_to @actor, notice: "会員情報を更新しました。"
    else
      render "edit"
    end
  end

  def destroy
    @actor = Actoraccount.find(params[:id])
    @actor.destroy
    redirect_to :root, notice: "会員を削除しました。"

  end

  def actor_false_stages
    @stages = Stage.where(actoraccount_id: session[:actor_id]).where(status: "申請中")
  end

  def actor_true_stages
    @stages = Stage.where(actoraccount_id: session[:actor_id]).where(status: "承認")
  end

  def actor_stage_show
    @stage = Stage.find(params[:id])
    @count = Stage.find(params[:id]).reservations.count
  end
end