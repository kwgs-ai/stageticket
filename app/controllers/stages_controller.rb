class StagesController < ApplicationController
  before_action :actor_login_required, only: [:new]

  def index
    @link = 'stage'
    @stages = Stage.where('date >= ?', Date.today).where(status: 2).order(:date)
                   .page(params[:page]).per(5)
  end

  def show
    @stage = Stage.find(params[:id])
  end

  def new
    @stage = Stage.new
    @seat = Seat.new
  end

  def edit
    @stage = Stage.find(params[:id])
    @seat_s = @stage.seats.find_by(seat_type: 'S').seat_prise
    @seat_a = @stage.seats.find_by(seat_type: 'A').seat_prise
    @seat_b = @stage.seats.find_by(seat_type: 'B').seat_prise
  end

  def update
    @stage = Stage.find(params[:id])
    @stage.assign_attributes(params[:stage])
    @seats_s = @stage.seats.where(seat_type: 'S')
    @seats_a = @stage.seats.where(seat_type: 'A')
    @seats_b = @stage.seats.where(seat_type: 'B')

    @seats_s.each do |seat|
      seat.assign_attributes(seat_prise: params[:S_prise])
      seat.save
    end
    @seats_a.each do |seat|
      seat.assign_attributes(seat_prise: params[:A_prise])
      seat.save
    end
    @seats_b.each do |seat|
      seat.assign_attributes(seat_prise: params[:B_prise])
      seat.save
    end
    if @stage.save
      if current_admin
        redirect_to admin_false_stages_admin_path, notice: 'この公演のステータスを更新しました'
      elsif current_actor
        redirect_to actor_stage_show_stage_path(@stage), notice: '舞台情報を更新しました。'
      else
        redirect_to @stage, notice: '舞台情報を更新しました。'
      end
    else
      render 'edit'
    end
  end

  def confirm
    @s = params[:S_prise]
    @a = params[:A_prise]
    @b = params[:B_prise]
    @stage = Stage.new(params[:stage])
    @stage.actor_id = session[:actor_id]
    @seat = Seat.new(seat_type: 'S', stage_id: @stage.id, seat_prise: @s)
    @seat = Seat.new(seat_type: 'A', stage_id: @stage.id, seat_prise: @a)
    @seat = Seat.new(seat_type: 'B', stage_id: @stage.id, seat_prise: @b)

  end

  def create
    @s = params[:S_prise]
    @a = params[:A_prise]
    @b = params[:B_prise]
    @stage = Stage.new(params[:stage])
    @stage.actor_id = session[:actor_id]
    @seat = Seat.new(seat_type: 'S', stage_id: @stage.id, seat_prise: @s)
    @label = true

    10.times do
      @seat = Seat.new(seat_type: 'S', stage_id: @stage.id, seat_prise: @s)
      unless @seat.save
        @label = false
        break
      end
    end
    10.times do
      @seat = Seat.new(seat_type: 'A', stage_id: @stage.id, seat_prise: @a)
      unless @seat.save
        @label = false
        break
      end
    end
    10.times do
      @seat = Seat.new(seat_type: 'B', stage_id: @stage.id, seat_prise: @b)
      unless @seat.save
        @label = false
        break
      end
    end
    if @label
      if @stage.save
        redirect_to :root, notice: '登録しました'
      else
        render 'new'
      end
    else
      render 'new'
    end

  end

  def search
    @stages = Stage.search(params[:title], params[:date], params[:morning], params[:afternoon], params[:actor], params[:category])
    @stages = @stages.where(status: 2)
    render 'index'
  end

  def admin_stage_show
    @stage = Stage.find(params[:id])
    @s = @stage.seats.find_by(seat_type: 'S').seat_prise
    @a = @stage.seats.find_by(seat_type: 'A').seat_prise
    @b = @stage.seats.find_by(seat_type: 'B').seat_prise
    @count = Stage.find(params[:id]).reservations.count
  end

  def actor_stage_show
    @stage = Stage.find(params[:id])
  end

end
