class Actor < ApplicationRecord
  has_secure_password
  has_many :stages, dependent: :destroy

end
