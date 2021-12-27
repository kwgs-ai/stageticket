class Actor < ApplicationRecord
  has_secure_password
  has_many :stages, dependent: :destroy

  attr_accessor :current_password

  validates :password, presence: { if: :current_password }
  validates :name, presence: true,
                   length: { minimum: 2, maximum: 20, allow_blank: true },
                   uniqueness: true
  validates :login_name, presence: true,
                         length: { minimum: 4, maximum: 16, allow_blank: true }
  validates :login_name, presence: true,
                         length: { minimum: 4, maximum: 16, allow_blank: true }
  

end
