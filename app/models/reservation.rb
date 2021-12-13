class Reservation < ApplicationRecord
  belongs_to :stage, optional: true
  belongs_to :useraccount
  has_one :seat, dependent: :destroy

end
