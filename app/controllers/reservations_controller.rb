class ReservationsController < ApplicationController
  def new
    @stage = Stage.find(params[:stage_id])
    @reservation = Reservation.new
  end
  def create

  end
end
