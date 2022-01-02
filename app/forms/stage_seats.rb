class StageSeats
  include ActiveModel::Model
  include ActiveRecord::AttributeAssignment

  attr_accessor :title, :text, :date, :time, :actor_id, :category_id, :seat_prise, :collection,
                :stage, :errors, :prise

  SEAT_NUM = 3

  def initialize(attributes = [], attributes2 = [], actor = nil)
    if attributes.present?
      self.collection = []
      types = %w[S A B]
      self.prise = []
      self.stage = Stage.new(actor_id: actor, title: attributes[:title], text: attributes[:text],
                             date: attributes[:date], time: attributes[:time], category_id: attributes[:category_id])
      collection << stage
      attributes2.each_with_index do |value, i|
        prise << value['seat_prise']
        0.upto(9) { collection << Seat.new(seat_prise: value['seat_prise'], seat_type: types[i]) }
      end
    else
      self.collection = SEAT_NUM.times.map { Seat.new }
    end
  end

  def assign_attributes(stage, attributes, update_seat)
    date = attributes['date(1i)'] ? Date.parse("#{attributes['date(1i)']}-#{attributes['date(2i)']}-#{attributes['date(3i)']}") : attributes['date']

    stage.assign_attributes(title: attributes[:title], text: attributes[:text],
                            date: date, time: attributes[:time], category_id: attributes[:category_id])
    stage.assign_attributes(status: attributes[:status]) if attributes[:status]
    seats_s = stage.seats.where(seat_type: 'S')
    seats_a = stage.seats.where(seat_type: 'A')
    seats_b = stage.seats.where(seat_type: 'B')
    self.collection = []
    collection << stage
    seat_prise = update_seat.values
    seats_s.each do |seat|
      seat.assign_attributes(seat_prise: seat_prise[0][:seat_prise])
      collection << seat
    end
    seats_a.each do |seat|
      seat.assign_attributes(seat_prise: seat_prise[1][:seat_prise])
      collection << seat
    end
    seats_b.each do |seat|
      seat.assign_attributes(seat_prise: seat_prise[2][:seat_prise])
      collection << seat
    end
  end

  def save
    errors = []
    ActiveRecord::Base.transaction do
      errors << collection.first.errors.full_messages unless collection.first.save
      collection.drop(1).each do |result|
        result.stage_id = collection.first.id
        break errors << result.errors.full_messages unless result.save
      end
      raise ActiveRecord::RecordInvalid if errors.present?
    end
  rescue => e
    p 'エラーがあります＜デバッグ用＞'
    p e
    self.collection = []
    collection << stage
    3.times { |id| collection << Seat.new(seat_prise: prise[id]) }
  ensure
    return errors
  end
end

