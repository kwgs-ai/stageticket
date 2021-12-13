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
      if current_admin
        redirect_to admin_stage_show_adminaccount_path(@stage), notice: '会員情報を更新しました。'
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
    @stage.actoraccount_id = session[:actor_id]
  end

  def create
    @s = params[:S_cost]
    @a = params[:A_cost]
    @b = params[:B_cost]
    @stage = Stage.new(params[:stage])
    @stage.actoraccount_id = session[:actor_id]
    if @stage.save
      10.times do
        @seat = Seat.new(seat_type: 'S', stage_id: @stage.id, cost: @s)
        @seat.save
      end
      10.times do
        @seat = Seat.new(seat_type: 'A', stage_id: @stage.id, cost: @a)
        @seat.save
      end
      10.times do
        @seat = Seat.new(seat_type: 'B', stage_id: @stage.id, cost: @b)
        @seat.save
      end
      redirect_to :root, notice: '登録しました'
    else
      render 'new'
    end

  end

  def search
    if params[:actor].present?
      @actors = Actoraccount.where('actor_name LIKE ?', "%#{params[:actor]}%")
      @actors.each do |actor|
        @stages = actor.stages
        @stages = @stages.search(params[:title], params[:date], params[:morning], params[:afternoon])
      end
    else
      @stages = Stage.search(params[:title], params[:date], params[:morning], params[:afternoon])
    end
    render 'index'
  end

end
