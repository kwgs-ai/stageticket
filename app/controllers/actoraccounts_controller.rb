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

end