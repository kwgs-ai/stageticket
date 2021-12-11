class Actoraccount < ApplicationRecord
  has_secure_password
  belongs_to :stage
end
