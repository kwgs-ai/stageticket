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
    if params[:actor_id]
      @stages = Actor.find(params[:actor_id]).stages
      render 'actors/actor_true_stages'
    end
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
    @seats = []
    @errors = []
    @cost = [@stage_date[:seats][0]['seat_prise'], @stage_date[:seats][1]['seat_prise'],
             @stage_date[:seats][2]['seat_prise']]
    @form = StageSeats.new(params[:stage_seats], params[:stage_seats][:seats], cookies.signed[:actor_id])
    @stage = @form.collection.first

    @stage.errors.full_messages.each {|e|@errors << e} if @form.collection.first.invalid?

    @seats << @form.collection[2]
    @seats << @form.collection[8]
    @seats << @form.collection[20]
    @seat_date = @form.collection.drop(1)
    @seat_date.length
    @seat_date.each do |seat|
       seat.stage_id = 1
      break seat.errors.full_messages.each {|e|@errors << e} if seat.invalid?
    end
    @stage = @form.collection.first
    render "new" if @errors.present?

  end

  def new
    @form = StageSeats.new
    @stage = Stage.new
    @seats = @form.collection
  end

  def create
    @seats = []
    @form = StageSeats.new(params[:stage_seats], params[:stage_seats][:seats], cookies.signed[:actor_id])
    if  params[:back].nil? && (@error = @form.save).blank?
      redirect_to :root, notice: '登録しました'
    else
      @seats << @form.collection[2]
      @seats << @form.collection[8]
      @seats << @form.collection[20]
      p @seats
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

  def actor_true_stages
    @link = 'actor_stage_show_stage'
    @stages = Stage.where(actor_id: params[:actor_id]).where('date >= ?', Date.today)
                   .page(params[:page]).per(3)
    @after = Stage.where(actor_id: params[:actor_id]).where('date < ?', Date.today)
                  .page(params[:page]).per(3)
  end
end
