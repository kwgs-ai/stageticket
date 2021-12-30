class StageSeats
  include ActiveModel::Model
  attr_accessor :title, :text, :date, :time, :actor_id, :category_id, :seat_prise, :collection,
                :stage, :errors, :prise_a, :prise_b, :prise_s

  SEAT_NUM = 3
  def initialize(attributes = [], attributes2 = [], actor=nil)
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
          self.collection <<
            Seat.new(
              seat_prise: value['seat_prise'],
              # stage_id: 1,
              seat_type: types[count]
            )
          if count == 0
            self.prise_s = value['seat_prise']
          elsif  count == 1
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

  def save
    errors = []
    ActiveRecord::Base.transaction do
      unless stage.save
        errors << stage.errors.full_messages
      end
      collection.each do |result|
        result.stage_id = stage.id
        # バリデーションを全てかけたいからsave!ではなくsaveを使用
        unless result.save
          errors << result.errors.full_messages
          break
        end
      end
      # バリデーションエラーがあった時は例外を発生させてロールバックさせる
      # raise ActiveRecord::RecordInvalid unless is_success
      raise ActiveRecord::RecordInvalid if errors.present?
    end
  rescue
    p 'エラーがあります＜デバッグ用＞'
    # self.collection = SEAT_NUM.times.map { Seat.new }
    self.collection = []
    self.collection << Seat.new(seat_prise: prise_s)
    self.collection << Seat.new(seat_prise: prise_a)
    self.collection << Seat.new(seat_prise: prise_b)
    p collection
    p prise_s
  ensure
    return errors
  end
end


def save
  errors = []
  ActiveRecord::Base.transaction do
    [[:name => "Alice"], [:name => "Bob"], [:name => "Charlie"]].each do |row|
      person = Person.new(row)
      if !person.save
        errors << person.errors.full_messages
      end
    end

  end
  # ここが重要だった
  errors.presence || nil
end
