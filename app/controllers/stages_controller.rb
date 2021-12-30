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

  def edit
    @stage = Stage.find(params[:id])
    @seat = @stage.seats.find_by(seat_type: 'S')
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
    @seat = @stage.seats.find_by(seat_type: 'S')
    @label = true
    @seats_s.each do |seat|
      seat.assign_attributes(seat_prise: params[:S_prise])
      unless seat.save
        @label = false
      end
    end
    @seats_a.each do |seat|
      seat.assign_attributes(seat_prise: params[:A_prise])
      unless seat.save
        @label = false
      end
    end
    @seats_b.each do |seat|
      seat.assign_attributes(seat_prise: params[:B_prise])
      unless seat.save
        @label = false
      end
    end
    @seat = @stage.seats.find_by(seat_type: 'S')
    @seat.assign_attributes(seat_prise: params[:S_prise])
    unless @seat.save
      @label = false
    end
    @seat = @stage.seats.find_by(seat_type: 'A')
    @seat.assign_attributes(seat_prise: params[:A_prise])
    unless @seat.save
      @label = false
    end
    @seat = @stage.seats.find_by(seat_type: 'B')
    @seat.assign_attributes(seat_prise: params[:B_prise])
    unless @seat.save
      @label = false
    end

    if @stage.save && @label
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
    @stage_date = params[:stage_seats]
    @seat = @stage_date[:seats]
    @actor = session[:actor_id]
    @date = Date.parse("#{@stage_date["date(1i)"]}-#{@stage_date["date(2i)"]}-#{@stage_date["date(3i)"]}")
    @stage = Stage.new(title: @stage_date[:title], text: @stage_date[:text],
                           date: @date, time: @stage_date[:time], category_id: @stage_date[:category_id],actor_id: session[:actor_id])
    @seats = StageSeats.new()
    @s = @stage_date[:seats][0]['seat_prise']
    @a = @stage_date[:seats][1]['seat_prise']
    @b = @stage_date[:seats][2]['seat_prise']
  end

  def new
    @seats = StageSeats.new
  end

  def create
    @stage_date = params[:stage_seats]
    @seat = @stage_date[:seats]
    @actor = session[:actor_id]
    @seats = StageSeats.new(@stage_date, @seat, @actor)
    if (@error = @seats.save).blank?
      redirect_to :root, notice: '登録しました'
    else
      render 'new'
    end
  end

  def search
    @stages = Stage.search(params[:title], params[:date], params[:morning], params[:afternoon], params[:actor], 
                           params[:category]).where(status: 2)
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
