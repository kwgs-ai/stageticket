class StageSeats
  include ActiveModel::Model
  attr_accessor :title, :text, :date, :time, :actor_id, :category_id, :seat_prise, :collection,
                :stage, :errors, :prise_a, :prise_b, :prise_s

  SEAT_NUM = 3

  def initialize(attributes = [], attributes2 = [], actor = nil)
    if attributes.present?
      self.collection = []
      types = %w[S A B]
      count = 0
      # date = Date.parse("#{attributes["date(1i)"]}-#{attributes["date(2i)"]}-#{attributes["date(3i)"]}")
      self.stage = Stage.new(title: attributes[:title], text: attributes[:text],
                             date: attributes[:date], time: attributes[:time], category_id: attributes[:category_id])
      stage.actor_id = actor
      attributes2.each do |value|
        0.upto(9) do |idx|
          collection <<
            Seat.new(
              seat_prise: value['seat_prise'],
              # stage_id: 1,
              seat_type: types[count]
            )
          if count == 0
            self.prise_s = value['seat_prise']
          elsif count == 1
            self.prise_a = value['seat_prise']
          else
            self.prise_b = value['seat_prise']
          end
        end
        count += 1
      end
    else
      self.collection = SEAT_NUM.times.map { Seat.new }
    end
  end

  def assign_attributes(stage,attributes,update_seat)
    date = Date.parse("#{attributes["date(1i)"]}-#{attributes["date(2i)"]}-#{attributes["date(3i)"]}")
    stage.assign_attributes(title: attributes[:title], text: attributes[:text],
                            date: date, time: attributes[:time], category_id: attributes[:category_id])
    self.stage = stage
    seats_s = stage.seats.where(seat_type: 'S')
    seats_a = stage.seats.where(seat_type: 'A')
    seats_b = stage.seats.where(seat_type: 'B')
    self.collection = []
    seat_prise = update_seat.values
    seats_s.each do |seat|
      seat.assign_attributes(seat_prise:  seat_prise[0][:seat_prise])
      collection << seat
    end
    seats_a.each do |seat|
      seat.assign_attributes(seat_prise:  seat_prise[1][:seat_prise])
      collection << seat
    end
    seats_b.each do |seat|
      seat.assign_attributes(seat_prise:  seat_prise[2][:seat_prise])
      collection << seat
    end
  end

  def save
    errors = []
    ActiveRecord::Base.transaction do
      p stage
      p collection
      unless stage.save
        errors << stage.errors.full_messages
        p errors.present?
      end
      collection.each do |result|
        result.stage_id = stage.id
        # バリデーションを全てかけたいからsave!ではなくsaveを使用
        unless result.save
          errors << result.errors.full_messages
          p errors.present?
          break
        end
      end

      raise ActiveRecord::RecordInvalid if errors.present?
    end
  rescue => e
    p 'エラーがあります＜デバッグ用＞'
    p errors.present?
    p e
    self.collection = []
    collection << Seat.new(seat_prise: prise_s)
    collection << Seat.new(seat_prise: prise_a)
    collection << Seat.new(seat_prise: prise_b)
  ensure
    return errors
  end
end

