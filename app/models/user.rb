class User < ApplicationRecord
  has_secure_password
  has_many :reservations, dependent: :destroy

  attr_accessor :current_password
  validates :password, presence: { if: :current_password }
end
