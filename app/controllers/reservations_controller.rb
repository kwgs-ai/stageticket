class ReservationsController < ApplicationController
  before_action :user_login_required, only: [:new]

  def index
    @reservations = Reservation.where(user_id: cookies.signed[:user_id])
                               .page(params[:page]).per(10)
  end

  def new
    @stage = Stage.find(params[:reservation]['stage_id'])
    @reservation = Reservation.new
    @user = current_user
    @errors = []
    ActiveRecord::Base.transaction do
      p 5555555555555555555555555555
      @reservation = Reservation.new(user_id: cookies.signed[:user_id], stage_id: @stage.id).id
      @s_seats = Seat.where('seat_type like ?', '%S%').where(stage_id: params[:stage_id], reservation_id: nil)
      @a_seats = Seat.where('seat_type like ?', '%A%').where(stage_id: params[:stage_id], reservation_id: nil)
      @b_seats = Seat.where('seat_type  like ?', '%B%').where(stage_id: params[:stage_id], reservation_id: nil)
      if params['seat'].nil?
        @errors << '座席が選択されていません'
      else
        @seat_types = params['seat']['seat_type']
        @errors << '一回の予約に取れるのは5席までです' if @seat_types.length >= 6
        p 44444444444444444444444444
        p @reservation
        if @reservation.valid?
          @seat_types.each do |seat|
            @seat = Seat.find_by(seat_type: seat, stage_id: params[:stage_id], reservation_id: nil)
            break @errors << 'その席は予約済みです' if @seat.nil?

            @seat.reservation_id = @reservation.id
            p 333333333333333333333
            p @seat
            break @errors << @seat.errors.full_messages unless @seat.valid?
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
    @errors = '予約を確認' unless @errors.present?
    if @errors.instance_of?(Array)
      redirect_to @stage, notice: @errors
    else
      @reservation = Reservation.new
      render 'new', notice: @errors
    end

  end

  def show
    @reservation = Reservation.find(params[:id])
    @cost = 0
    @stage = @reservation.stage
  end

  def create
    @errors = []
    @stage = Stage.find(params['stage_id'])
    @user = current_user
    @seat_types = params['seats']
    p @seat_types
    @reservation = Reservation.new(user_id: cookies.signed[:user_id], stage_id: Stage.find(params[:stage_id]).id)
    if params[:back].nil?
      ActiveRecord::Base.transaction do
        @reservation = Reservation.new(user_id: cookies.signed[:user_id], stage_id: Stage.find(params[:stage_id]).id)
        @s_seats = Seat.where('seat_type like ?', '%S%').where(stage_id: params[:stage_id], reservation_id: nil)
        @a_seats = Seat.where('seat_type like ?', '%A%').where(stage_id: params[:stage_id], reservation_id: nil)
        @b_seats = Seat.where('seat_type  like ?', '%B%').where(stage_id: params[:stage_id], reservation_id: nil)
        if params['seats'].nil?
          @errors << '座席が選択されていません'
        else
          @errors << '一回の予約に取れるのは5席までです' if @seat_types.length >= 6
          if @reservation.save
            @seat_types.each do |seat|
              @seat = Seat.find_by(seat_type: seat, stage_id: @stage.id, reservation_id: nil)
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
    else
      @errors = '確認修正'
    end
  rescue => e
    p 'エラーがあります＜デバッグ用＞'
    p e
  ensure
    # @errors = '予約が完了しました' unless @errors.present?
    if @errors.present?
      p @errors
      render 'stages/show'
    else
      redirect_to [@reservation.user, @reservation], notice: '予約が完了しました'
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
