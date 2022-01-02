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
    ActiveRecord::Base.transaction do
      @reservation = Reservation.new(user_id: session[:user_id], stage_id: Stage.find(params[:stage_id]).id)
      @s_seats = Seat.where(seat_type: 'S', stage_id: params[:stage_id], reservation_id: nil)
      @a_seats = Seat.where(seat_type: 'A', stage_id: params[:stage_id], reservation_id: nil)
      @b_seats = Seat.where(seat_type: 'B', stage_id: params[:stage_id], reservation_id: nil)
      @sum = @s_count = params[:s_count].to_i + @a_count = params[:a_count].to_i + @b_count = params[:b_count].to_i
      @errors << '席数は０以上６未満です' if @sum <= 0 || @sum > 6
      @errors << 'あき席数が足りないです' if @s_seats.count < @s_count || @a_seats.count < @a_count || @b_seats.count < @b_count
      if @reservation.save
        @s_count.times do |i|
          @s_seats[i].reservation_id = @reservation.id
          unless @s_seats[i].save
            @errors << @s_seats[i].errors.full_messages
            break
          end
        end
        @a_count.times do |i|
          @a_seats[i].reservation_id = @reservation.id
          unless  @a_seats[i].save
            @errors << @a_seats[i].errors.full_messages
            break
          end
        end
        @b_count.times do |i|
          @b_seats[i].reservation_id = @reservation.id
          unless @b_seats[i].save
            @errors << @b_seats[i].errors.full_messages
            break
          end
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
    @errors << "予約完了" unless @errors.present?
    redirect_to :root, notice: @errors
  end

  def destroy
    @reservation = Reservation.find(params[:id])
    @stage = @reservation.stage_id
    if Stage.find(@stage).date >= Date.today + 2
      @reservation.destroy
      redirect_to user_reservations_path, notice: '予約をキャンセルしました'
    else
      redirect_to user_reservation_path, notice: 'この予約はキャンセルできません'
    end
  end
end
