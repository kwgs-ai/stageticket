class StagesController < ApplicationController
  before_action :actor_login_required, only: [:new]

  def index
    @link = 'admin_stage_show_stage'
    @stages = Stage.where(status: 2)
  end

  def show
    @stage = Stage.find(params[:id])
  end

  def new
    @stage = Stage.new
  end

  def edit
    @stage = Stage.find(params[:id])
  end

  def update
    @stage = Stage.find(params[:id])
    @stage.assign_attributes(params[:stage])
    if @stage.save
      if current_admin
        redirect_to admin_stage_show_admin_stage_path(@stage), notice: '会員情報を更新しました。'
      else
        redirect_to @stage, notice: '会員情報を更新しました。'
      end
    else
      render 'edit'
    end
  end

  def confirm
    @s = params[:S_cost]
    @a = params[:A_cost]
    @b = params[:B_cost]
    @stage = Stage.new(params[:stage])
    @stage.actor_id = session[:actor_id]
  end

  def create
    @s = params[:S_cost]
    @a = params[:A_cost]
    @b = params[:B_cost]
    @stage = Stage.new(params[:stage])
    @stage.actor_id = session[:actor_id]
    if @stage.save!
      10.times do
        @seat = Seat.new(seat_type: 'S', stage_id: @stage.id, seat_prise: @s)
        @seat.save
      end
      10.times do
        @seat = Seat.new(seat_type: 'A', stage_id: @stage.id, seat_prise: @a)
        @seat.save
      end
      10.times do
        @seat = Seat.new(seat_type: 'B', stage_id: @stage.id, seat_prise: @b)
        @seat.save
      end
      redirect_to :root, notice: '登録しました'
    else
      render 'new'
    end

  end

  def search
    @stages = Stage.search(params[:title], params[:date], params[:morning], params[:afternoon], params[:actor],params[:category])
    @stages = @stages.where(status: 2)
    render 'index'
  end

  def admin_stage_show
    @stage = Stage.find(params[:id])
    @count = Stage.find(params[:id]).reservations.count
  end

  def actor_stage_show
    @stage = Stage.find(params[:id])
  end

end
