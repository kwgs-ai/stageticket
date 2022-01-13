class StagesController < ApplicationController
  before_action :actor_login_required, only: [:new]

  def bad_request
    raise ActionController::ParameterMissing, ''
  end

  def forbidden
    raise Forbidden, ''
  end

  def internal_server_error
    raise
  end

  def index
    @link = 'stage'
    @stages = Stage.where('date >= ?', Date.current).where(status: 2).order(:date)
                   .page(params[:page]).per(4)
  end

  def search
    @link = 'stage'
    @stages = Stage.search(params[:title], params[:date], params[:time], params[:actor],
                           params[:category])
                   .page(params[:page]).per(4)
    render 'index'
  end

  def show
    @stage = Stage.find(params[:id])
  end

  def edit
    @stage = Stage.find(params[:id])
    @seats = [@stage.seats.find_by('seat_type like ?', '%S%'), @stage.seats.find_by('seat_type like ?', '%A%'),
              @stage.seats.find_by('seat_type like ?', '%B%')]
  end

  def update
    @seats = StageSeats.new
    @stage = Stage.find(params[:id])
    @seats.assign_attributes(@stage, params[:stage], params[:stage][:seats])
    if (@error = @seats.save).blank?
      if current_actor
        redirect_to actor_stage_show_stage_path(@stage), notice: '更新しました'
      else
        redirect_to admin_false_stages_admin_path, notice: '更新しました'
        end
    else
      @seats = [@stage.seats.find_by('seat_type like ?', '%S%'), @stage.seats.find_by('seat_type like ?', '%A%'), 
                @stage.seats.find_by('seat_type like ?', '%B%')]
      render 'edit'
    end
  end

  def confirm
    @stage_date = params[:stage_seats]
    @date = Date.parse("#{@stage_date["date(1i)"]}-#{@stage_date["date(2i)"]}-#{@stage_date["date(3i)"]}")
    @stage = Stage.new(title: @stage_date[:title], text: @stage_date[:text],
                       date: @date, time: @stage_date[:time], category_id: @stage_date[:category_id], actor_id: cookies.signed[:actor_id])
    @form = StageSeats.new
    @seats = @form.collection
    @cost = [@stage_date[:seats][0]['seat_prise'], @stage_date[:seats][1]['seat_prise'], 
             @stage_date[:seats][2]['seat_prise']]
  end

  def new
    @form = StageSeats.new
    @stage = Stage.new
    @seats = @form.collection
  end

  def create
    @form = StageSeats.new(params[:stage_seats], params[:stage_seats][:seats], cookies.signed[:actor_id])
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
    @seats = [@stage.seats.find_by('seat_type like ?', '%S%'), @stage.seats.find_by('seat_type like ?', '%A%'),
              @stage.seats.find_by('seat_type like ?', '%B%')]
  end

  def actor_stage_show
    @stage = Stage.find(params[:id])
  end

end
