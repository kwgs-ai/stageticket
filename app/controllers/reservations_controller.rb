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
    @user = User.find(params[:user_id])
    @stage = @reservation.stage
  end

  def create
    @errors = []
    ActiveRecord::Base.transaction do
      @stage = Stage.find(params[:stage_id])
      @reservation = Reservation.new(user_id: session[:user_id], stage_id: @stage.id)
      @a_seats = Seat.where(seat_type: 'S', stage_id: params[:stage_id], reservation_id: nil)
      @s_seats = Seat.where(seat_type: 'A', stage_id: params[:stage_id], reservation_id: nil)
      @b_seats = Seat.where(seat_type: 'B', stage_id: params[:stage_id], reservation_id: nil)
      @s_count = params[:s_count].to_i
      @a_count = params[:a_count].to_i
      @b_count = params[:b_count].to_i
      @sum = @s_count + @a_count + @b_count
      @errors << '席数は０以上６未満です' if @sum <= 0 || @sum > 6
      @errors << 'あき席数が足りないです' if @s_seats.count < @s_count || @a_seats.count < @a_count || @b_seats.count < @b_count
      if @reservation.save
        @s_count.times do
          @seat = Seat.find_by(seat_type: 'S', stage_id: params[:stage_id], reservation_id: nil)
          @seat.reservation_id = @reservation.id
          unless @seat.save
            @errors << @seat.errors.full_messages
            break
          end
        end
        @a_count.times do
          @seat = Seat.find_by(seat_type: 'A', stage_id: params[:stage_id], reservation_id: nil)
          @seat.reservation_id = @reservation.id
          unless @seat.save
            @errors << @seat.errors.full_messages
            break
          end
        end
        @b_count.times do
          @seat = Seat.find_by(seat_type: 'B', stage_id: params[:stage_id], reservation_id: nil)
          @seat.reservation_id = @reservation.id
          unless @seat.save
            @errors << @seat.errors.full_messages
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
    @errors << "予約完了"
    redirect_to :root, notice: @errors
  end

  def destroy
    @reservation = Reservation.find(params[:id])
    @stage = @reservation.stage_id
    if Stage.find(@stage).date >= Date.today + 2
      @reservation.destroy
      redirect_to :root, notice: '会員を削除しました。'
    end
  end
end
