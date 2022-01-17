class ReservationsController < ApplicationController
  before_action :user_login_required, only: [:new]

  def index
    @reservations = Reservation.where(user_id: cookies.signed[:user_id])
                      .page(params[:page]).per(10)
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
    @user = current_user
    ActiveRecord::Base.transaction do
      @reservation = Reservation.new(user_id: cookies.signed[:user_id], stage_id: Stage.find(params[:stage_id]).id)
      @s_seats = Seat.where('seat_type like ?', '%S%').where(stage_id: params[:stage_id], reservation_id: nil)
      @a_seats = Seat.where('seat_type like ?', '%A%').where(stage_id: params[:stage_id], reservation_id: nil)
      @b_seats = Seat.where('seat_type  like ?', '%B%').where(stage_id: params[:stage_id], reservation_id: nil)
      if params['seat'].nil?
        @errors << '座席が選択されていません'
      else
        @seat_types = params['seat']['seat_type']
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
      end
      raise ActiveRecord::RecordInvalid if @errors.present?
    end
  rescue => e
    p 'エラーがあります＜デバッグ用＞'
    p e
  ensure
    @errors = '予約が完了しました' unless @errors.present?
    if @errors.instance_of?(Array)
      render "new"
    else
      redirect_to [@reservation.user,@reservation], notice: @errorserrors
    end

  end

  def destroy
    @reservation = Reservation.find(params[:id])
    # if @reservation.stage.date >= Date.current.days_since(2)
    if @reservation.destroy
      redirect_to user_reservations_path, notice: '予約をキャンセルしました'
    else
      redirect_to user_reservation_path, notice: @reservation.errors.full_messages
      end
    # else
    #   redirect_to user_reservation_path, notice: 'この予約はキャンセルできません'
    # end
  end
end
