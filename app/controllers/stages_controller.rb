class StagesController < ApplicationController
  before_action :actor_login_required, only: [:new]

  def bad_request
    raise ActionController::ParameterMissing, ""
  end

  def forbidden
    raise Forbidden, ""
  end

  def internal_server_error
    raise
  end

  def index
    @link = 'stage'
    @stages = Stage.where('date >= ?', Date.today).where(status: 2).order(:date)
                   .page(params[:page]).per(5)
  end

  def search
    @link = 'stage'
    @stages = Stage.search(params[:title], params[:date], params[:morning], params[:afternoon], params[:actor],
                           params[:category])
                   .page(params[:page]).per(5)
    render 'index'
  end

  def show
    @stage = Stage.find(params[:id])
  end

  def edit
    @stage = Stage.find(params[:id])
    @seats = [@stage.seats.find_by(seat_type: 'S'), @stage.seats.find_by(seat_type: 'A'),
              @stage.seats.find_by(seat_type: 'B')]
  end

  def update
    @seats = StageSeats.new
    @stage = Stage.find(params[:id])
    @seats.assign_attributes(@stage, params[:stage], params[:stage][:seats])
    if (@error = @seats.save).blank?
      if current_actor
        redirect_to :root, notice: '登録しました'
      else
        redirect_to admin_false_stages_admin_path, notice: '登録しました'
        end
    else
      @seats = [@stage.seats.find_by(seat_type: 'S'), @stage.seats.find_by(seat_type: 'A'), @stage.seats.find_by(seat_type: 'B')]
      render 'edit'
    end
  end

  def confirm
    @stage_date = params[:stage_seats]
    @date = Date.parse("#{@stage_date["date(1i)"]}-#{@stage_date["date(2i)"]}-#{@stage_date["date(3i)"]}")
    @stage = Stage.new(title: @stage_date[:title], text: @stage_date[:text],
                       date: @date, time: @stage_date[:time], category_id: @stage_date[:category_id], actor_id: session[:actor_id])
    @form = StageSeats.new
    @seats = @form.collection
    @cost = [@stage_date[:seats][0]['seat_prise'], @stage_date[:seats][1]['seat_prise'], @stage_date[:seats][2]['seat_prise']]
  end

  def new
    @form = StageSeats.new
    @stage = Stage.new
    @seats = @form.collection
  end

  def create
    @form = StageSeats.new( params[:stage_seats],  params[:stage_seats][:seats], session[:actor_id])
    if (@error = @form.save).blank?
      redirect_to current_actor, notice: '登録しました'
    else
      @seats = @form.collection.drop(1)
      @stage = @form.collection.first
      render 'new'
    end
  end

  def admin_stage_show
    @stage = Stage.find(params[:id])
    @seats = [@stage.seats.find_by(seat_type: 'S'), @stage.seats.find_by(seat_type: 'A'),
              @stage.seats.find_by(seat_type: 'B')]
    @count = Stage.find(params[:id]).reservations.count
  end

  def actor_stage_show
    @stage = Stage.find(params[:id])
  end

end
