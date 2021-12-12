class StagesController < ApplicationController

  def index
    @stages = Stage.all
  end

  def new
    @stage = Stage.new
  end
  def create

  end

  def search
    if params[:actor].present?
      @stages = Stage.left_joins(:actoraccounts).where("actor_name LIKE ?","%#{params[:actor]}%")
    end
    @stages = @stages.search(params[:title], params[:date], params[:morning], params[:afternoon])

    render "index"
  end
end
