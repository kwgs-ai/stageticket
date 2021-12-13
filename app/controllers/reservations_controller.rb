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
    @reservation = Reservation.new(params[:reservation])
    @reservation.useraccount_id = session[:user_id]
    @reservation.stage_id = @stage.id
    if @reservation.save
      redirect_to :root, notice: "登録しました"
    else
      render "new"
    end
  end

  def index
    @reservations = Reservation.where(useraccount_id: params[:useraccount_id])
  end
end
