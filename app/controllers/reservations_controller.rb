class ReservationsController < ApplicationController
  def new
    @stage = Stage.find(params[:stage_id])
    @reservation = Reservation.new
  end
  def create
    @stage = Stage.find(params[:stage_id])
    @reservation = Reservation.new()
    @reservation.useraccount_id = session[:user_id]
    @reservation.stages << @stage
    if @reservation.save!
      redirect_to :root, notice: "登録しました"
    else
      render "new"
    end

  end
end
