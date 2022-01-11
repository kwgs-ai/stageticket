class ReservationsController < ApplicationController
  before_action :user_login_required, only: [:new]

  def index
    @reservations = Reservation.where(user_id: session[:user_id])
  end

  def new
    @stage = Stage.find(params[:stage_id])
    @reservation = Reservation.new
  end

  def show
    @reservation = Reservation.find(params[:id])
    @cost = 0
    @stage = @reservation.stage
  end

  def create
    @errors = []
    @stage = Stage.find(params[:stage_id])
    p @seat_types = params['seat']['seat_type']
    ActiveRecord::Base.transaction do
      @reservation = Reservation.new(user_id: session[:user_id], stage_id: Stage.find(params[:stage_id]).id)
      @s_seats = Seat.where('seat_type like ?', '%S%').where(stage_id: params[:stage_id], reservation_id: nil)
      @a_seats = Seat.where('seat_type like ?', '%A%').where(stage_id: params[:stage_id], reservation_id: nil)
      @b_seats = Seat.where('seat_type  like ?', '%B%').where(stage_id: params[:stage_id], reservation_id: nil)
      @sum = @s_count = params[:s_count].to_i + @a_count = params[:a_count].to_i + @b_count = params[:b_count].to_i
      @errors << '一回の予約に取れるのは６席までです' if @sum > 6
      @errors << 'あき席数が足りないです' if @s_seats.count < @s_count || @a_seats.count < @a_count || @b_seats.count < @b_count
      if @reservation.save
        @seat_types.each do |seat|
          @seat = Seat.find_by(seat_type: seat, stage_id: params[:stage_id], reservation_id: nil)
          break @errors << 'その席は予約済みです' if  @seat.nil?

          @seat.reservation_id = @reservation.id
          break @errors << @seat.errors.full_messages unless @seat.save
        end
      else
        @errors << @reservation.errors.full_messages
      end
      raise ActiveRecord::RecordInvalid if @errors.present?
    end
  rescue => e
    p 'エラーがあります＜デバッグ用＞'
    p e
  ensure
    @errors = '予約完了' unless @errors.present?
    render "new"
  end

  def destroy
    @reservation = Reservation.find(params[:id])
    @stage = @reservation.stage_id
    if Stage.find(@stage).date >= Date.today.days_since(2)
      @reservation.destroy
      redirect_to user_reservations_path, notice: '予約をキャンセルしました'
    else
      redirect_to user_reservation_path, notice: 'この予約はキャンセルできません'
    end
  end
end
