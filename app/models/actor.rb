class Actor < ApplicationRecord
  has_secure_password
  has_many :stages, dependent: :destroy

  attr_accessor :current_password

  validates :password, presence: { if: :current_password }

end
