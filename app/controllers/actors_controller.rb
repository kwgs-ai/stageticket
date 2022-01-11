class ActorsController < ApplicationController
  before_action :actor_login_required, only: [:index, :show]

  def index
    # @actor = Actor.new
  end

  def show
    @actor = current_actor
  end

  def new
    @actor = Actor.new
  end

  def create
    @actor = Actor.new(params[:actor])
    if @actor.save
      redirect_to :root, notice: "登録しました"
    else
      render "new"
    end
  end

  def edit
    @actor = Actor.find(params[:id])
  end

  def update
    @actor = Actor.find(params[:id])
    @actor.assign_attributes(params[:actor])
    if @actor.save
      redirect_to @actor, notice: "会員情報を更新しました。"
    else
      render "edit"
    end
  end

  def destroy
    @actor = Actor.find(params[:id])
    @actor.destroy
    cookies.delete(:actor_id)
    redirect_to :root, notice: "会員を削除しました。"

  end

  def actor_false_stages
    @link = 'actor_stage_show_stage'
    @stages = Stage.where(actor_id: cookies.signed[:actor_id]).where(status: 1).where('date >= ?', Date.today)
                   .page(params[:page]).per(3)
    @after = Stage.where(actor_id: cookies.signed[:actor_id]).where(status: 1).where('date < ?', Date.today)
                  .page(params[:page]).per(3)
  end

  def actor_true_stages
    @link = 'actor_stage_show_stage'
    @stages = Stage.where(actor_id: cookies.signed[:actor_id]).where(status: [2, 3]).where('date >= ?', Date.today)
                   .page(params[:page]).per(3)
    @after = Stage.where(actor_id: cookies.signed[:actor_id]).where(status: [2, 3]).where('date < ?', Date.today)
                  .page(params[:page]).per(3)
  end

  def actor_stage_show
    @stage = Stage.find(params[:id])
    @count = Stage.find(params[:id]).reservations.count
  end
end