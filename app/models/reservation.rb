class Reservation < ApplicationRecord
  has_many :stages, dependent: :destroy
  belongs_to :useraccount

end
