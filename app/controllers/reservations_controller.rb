class ReservationsController < ApplicationController
  before_action :user_login_required, only: [:new]
  def new
    @stage = Stage.find(params[:stage_id])
    @reservation = Reservation.new
  end

  def show
    @reservation = Reservation.find(params[:id])
  end

  def create
    @stage = Stage.find(params[:stage_id])
    @reservation = Reservation.new()
    @reservation.useraccount_id = session[:user_id]
    @reservation.stage_id = @stage.id
    @count = params[:count].to_i
    @seat = Seat.find_by(seat_type: params[:seat_type], stage_id: params[:stage_id], reservation_id: nil)
    @seats = Seat.where(seat_type: params[:seat_type], stage_id: params[:stage_id], reservation_id: nil)
    if @seats.count >= @count
      if @reservation.save
        @count.times do
          @seat = Seat.find_by(seat_type: params[:seat_type], stage_id: params[:stage_id], reservation_id: nil)
          @seat.stage_id = params[:stage_id]
          @seat.reservation_id = @reservation.id
          if @seat.save
          else
            break
          end
        end
        if true #@seat.save
          @id = 0
          # if @id == 0
          redirect_to :root, notice: "登録しました"
        else
          render "new"
        end
      else
        render "new"
      end
      # end

    else
      redirect_to :root, notice: "席がない"
    end
  end

  def index
    @reservations = Reservation.where(useraccount_id: params[:useraccount_id])
  end
end
