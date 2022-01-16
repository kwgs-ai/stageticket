class Reservation < ApplicationRecord
  belongs_to :stage, optional: true
  belongs_to :user
  has_many :seats, dependent: :nullify
  before_destroy :reservation_seats

  def reservation_seats
    p 111111111111111
    p self.stage.date <= Date.current.days_since(2)
    p self.stage.date
    p Date.current.days_since(3)
    if self.stage.date <= Date.current.days_since(3)
      errors.add(:reservation,'予約をキャンセルできませんできません')
      throw(:abort)
      end
  end

end
