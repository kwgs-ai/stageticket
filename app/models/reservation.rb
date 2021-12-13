class Reservation < ApplicationRecord
  belongs_to :stage, optional: true
  belongs_to :useraccount

end
