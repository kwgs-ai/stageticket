class Admin < ApplicationRecord
  has_secure_password

  attr_accessor :current_password

  validates :password, presence: { if: :current_password }
end
