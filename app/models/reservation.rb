class Reservation < ApplicationRecord
  belongs_to :stage, optional: true
  belongs_to :user
  has_one :seat, dependent: :destroy

end
