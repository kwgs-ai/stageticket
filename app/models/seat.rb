class Seat < ApplicationRecord
  MAX_COUNT = 6
  belongs_to :stage
  belongs_to :reservation, optional: true

  validates :seat_prise, presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validate do
    errors.add(:base, "一回の予約では６席までしか取れません: #{MAX_COUNT}") if stage.seats.where(reservation_id: nil).count >= MAX_COUNT
  end

end

