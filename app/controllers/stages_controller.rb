class StagesController < ApplicationController
  def index
    @stages = Stage.all
  end

  def search
    @stages = Stage.search(params[:title], params[:actor], params[:date], params[:morning], params[:afternoon])
    render "index"
  end
end
