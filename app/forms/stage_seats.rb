class StageSeats
  include ActiveModel::Model
  include ActiveRecord::AttributeAssignment

  attr_accessor :title, :text, :date, :time, :actor_id, :category_id, :seat_prise, :collection,
                :stage, :errors, :prise

  SEAT_NUM = 3

  def initialize(attributes = [], attributes2 = [], actor = nil)
    if attributes.present?
      self.collection = []
      self.prise = []
      types = %w[S A B]
      date = attributes['date']
      self.stage = Stage.new(actor_id: actor, title: attributes[:title], text: attributes[:text],
                             date: date, time: attributes[:time], category_id: attributes[:category_id])
      collection << stage
      attributes2.each_with_index do |value, i|
        prise << value['seat_prise']
        case i
        when 0
          1.upto(6) do |idx|
            collection << Seat.new(seat_prise: value['seat_prise'], seat_type: "#{types[i]}#{idx}")
          end
        when 1
          1.upto(12) do |idx|
            collection << Seat.new(seat_prise: value['seat_prise'], seat_type: "#{types[i]}#{idx}")
          end
        when 2
          1.upto(12) do |idx|
            collection << Seat.new(seat_prise: value['seat_prise'], seat_type: "#{types[i]}#{idx}")
          end
        end
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
    self.stage = stage
    seats_s = stage.seats.where('seat_type like ?', '%S%')
    seats_a = stage.seats.where('seat_type like ?', '%A%')
    seats_b = stage.seats.where('seat_type like ?', '%B%')
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
      p collection.first
       collection.first.errors.full_messages.each { |e| errors << e } unless collection.first.save
      p errors
      collection.drop(1).each do |result|
        result.stage_id = collection.first.id
        break result.errors.full_messages.each { |e| errors << e } unless result.save
      end
      raise ActiveRecord::RecordInvalid if errors.present?
    end
  rescue ActiveRecord::RecordInvalid => e
    p 'エラーがあります＜デバッグ用＞'
    p errors
  rescue ActiveModel::RangeError => e
    p 'エラーがあります＜デバッグ用＞'
    p e
    errors << '桁数が大きすぎます'
    p errors
    self.collection = []
    p collection << stage
    # 3.times { |id| collection << Seat.new(seat_prise: prise[id]) }
    return errors
  end
end

