class Reservation < ApplicationRecord
  belongs_to :stage, optional: true
  belongs_to :user
  has_many :seats, dependent: :destroy

end
