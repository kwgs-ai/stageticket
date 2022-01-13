class ReservationsController < ApplicationController
  before_action :user_login_required, only: [:new]

  def index
    @reservations = Reservation.where(user_id: cookies.signed[:user_id])
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
      @reservation = Reservation.new(user_id: cookies.signed[:user_id], stage_id: Stage.find(params[:stage_id]).id)
      @s_seats = Seat.where('seat_type like ?', '%S%').where(stage_id: params[:stage_id], reservation_id: nil)
      @a_seats = Seat.where('seat_type like ?', '%A%').where(stage_id: params[:stage_id], reservation_id: nil)
      @b_seats = Seat.where('seat_type  like ?', '%B%').where(stage_id: params[:stage_id], reservation_id: nil)
      @errors << '一回の予約に取れるのは5席までです' if @seat_types.length >= 6
      if @reservation.save
        @seat_types.each do |seat|
          @seat = Seat.find_by(seat_type: seat, stage_id: params[:stage_id], reservation_id: nil)
          break @errors << 'その席は予約済みです' if @seat.nil?
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
    if @errors.instance_of?(Array)
      render "new"
    else
      redirect_to :root, notice: @errors
    end

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
