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
    @stage = Stage.find(params[:stage_id])
    @reservation = Reservation.new
    @reservation.user_id = session[:user_id]
    @reservation.stage_id = @stage.id
    @s_count = params[:s_count].to_i
    @a_count = params[:a_count].to_i
    @b_count = params[:b_count].to_i
    @a_seats = Seat.where(seat_type: 'S', stage_id: params[:stage_id], reservation_id: nil)
    @s_seats = Seat.where(seat_type: 'A', stage_id: params[:stage_id], reservation_id: nil)
    @b_seats = Seat.where(seat_type: 'B', stage_id: params[:stage_id], reservation_id: nil)
    if @s_seats.count >= @s_count && @a_seats.count >= @a_count && @b_seats.count >= @b_count
      if @reservation.save
        @s_count.times do
          @seat = Seat.find_by(seat_type: 'S', stage_id: params[:stage_id], reservation_id: nil)
          @seat.stage_id = params[:stage_id]
          @seat.reservation_id = @reservation.id
          break unless @seat.save
        end
        @a_count.times do
          @seat = Seat.find_by(seat_type: 'A', stage_id: params[:stage_id], reservation_id: nil)
          @seat.stage_id = params[:stage_id]
          @seat.reservation_id = @reservation.id
          break unless @seat.save
        end
        @b_count.times do
          @seat = Seat.find_by(seat_type: 'B', stage_id: params[:stage_id], reservation_id: nil)
          @seat.stage_id = params[:stage_id]
          @seat.reservation_id = @reservation.id
          break unless @seat.save
        end
        redirect_to :root, notice: '登録しました'

      else
        render 'new'
      end
      # end

    else
      redirect_to :root, notice: '席数がたりませんでした'
    end
  end

end
