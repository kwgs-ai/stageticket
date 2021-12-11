class StagesController < ApplicationController
  before_action :actor_login_required
  def index
    @stages = Stage.all
  end

  def search
    if params[:actor].present?
      @stages = Stage.left_joins(:actoraccounts).where("actor_name LIKE ?","%#{params[:actor]}%")
    end
    @stages = @stages.search(params[:title], params[:date], params[:morning], params[:afternoon])

    render "index"
  end
end
