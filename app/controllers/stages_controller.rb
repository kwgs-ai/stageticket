class StagesController < ApplicationController
  # before_action :actor_login_required, only: [:new]
  def index
    if current_admin
    @stages = Stage.where(status: false)
    else
      @stages = Stage.where(status: true)
      end
  end

  def show
    @stage = Stage.find(params[:id])
  end
  def new
    @stage = Stage.new
  end
  def update
    @stage = Stage.find(params[:id])
    @stage.assign_attributes(params[:stage])
    if @stage.save
      redirect_to @stage, notice: "会員情報を更新しました。"
    else
      render "edit"
    end
  end

  def confirm
    @stage = Stage.new(params[:stage])
    @stage.actoraccount_id = session[:actor_id]
  end

  def create
    @stage = Stage.new(params[:stage])
    @stage.actoraccount_id = session[:actor_id]
    if @stage.save
      redirect_to :root, notice: "登録しました"
    else
      render "new"
    end

  end

  def search
    if params[:actor].present?
      @actors = Actoraccount.where("actor_name LIKE ?", "%#{params[:actor]}%")
      @actors.each do |actor|
        @stages = actor.stages
        @stages = @stages.search(params[:title], params[:date], params[:morning], params[:afternoon])
      end
    else
      @stages = Stage.search(params[:title], params[:date], params[:morning], params[:afternoon])
    end
    render "index"
  end

end
