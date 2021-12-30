class SeatCollection
  include ActiveModel::Model
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  include ActiveModel::AttributeMethods
  include ActiveModel::Validations
  SEAT_NUM = 1 # 同時にユーザーを作成する数
  attr_accessor :collection # ここに作成したユーザーモデルが格納される

  validates :seat_prise, presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 1 }

  # 初期化メソッド
  def initialize(attributes = [], stage = nil)
    if attributes.present?
      self.collection = []
      types = %w[S A B]
      attributes.each do |value|
        p value['seat_prise']
        0.upto(9) do |idx|
          self.collection <<
            Seat.new(
              seat_prise: value['seat_prise'],
              stage_id: stage,
              seat_type: types[idx % 3]
            )
        end
      end
    else
      self.collection = SEAT_NUM.times.map { Seat.new }
    end
    p collection
    p 111111111
  end

  # レコードが存在するか確認するメソッド
  def persisted?
    false
  end

  # コレクションをDBに保存するメソッド
  def save
    is_success = true
    ActiveRecord::Base.transaction do
      p collection[0]
      collection.each do |result|
        p result
        # バリデーションを全てかけたいからsave!ではなくsaveを使用
        unless result.save
          is_success = false
          self.collection = SEAT_NUM.times.map { Seat.new }
        end
      end
      # バリデーションエラーがあった時は例外を発生させてロールバックさせる
      raise ActiveRecord::RecordInvalid unless is_success
    end
  rescue
    p 'エラー'
  ensure
    return is_success
  end
end