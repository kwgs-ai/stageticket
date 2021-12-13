class ReservationsController < ApplicationController
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

    @seat = Seat.find_by(seat_type: params[:seat_type], stage_id: params[:stage_id], reservation_id: nil)
    if @seat != nil
      @seat.stage_id = params[:stage_id]

      if @reservation.save
        @seat.reservation_id = @reservation.id
        if @seat.save
          redirect_to :root, notice: "登録しました"
        else
          render "new"
        end
      else
        render "new"
      end
    else
      redirect_to :root, notice: "席がない"
    end
  end

  def index
    @reservations = Reservation.where(useraccount_id: params[:useraccount_id])
  end
end
