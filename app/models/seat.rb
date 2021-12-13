class Seat < ApplicationRecord
  belongs_to :stage
  belongs_to :reservation, optional: true
end

