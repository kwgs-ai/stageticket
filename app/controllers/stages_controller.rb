class StagesController < ApplicationController
  # before_action :actor_login_required, only: [:new]
  def index
    @stages = Stage.all
  end

  def new
    @stage = Stage.new
  end

  def confirm
    @stage = Stage.new(params[:stage])
    @stage.actoraccounts << current_actor
  end

  def create
    @stage = Stage.new(params[:stage])
    @stage.actoraccounts << current_actor
    if @stage.save
      redirect_to :root, notice: "登録しました"
    else
      render "new"
    end

  end

  def search
    if params[:actor].present?
      @stages = Stage.left_joins(:actoraccounts).where("actor_name LIKE ?", "%#{params[:actor]}%")
    end
    @stages = @stages.search(params[:title], params[:date], params[:morning], params[:afternoon])

    render "index"
  end

end
