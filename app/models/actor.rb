class Actor < ApplicationRecord
  has_secure_password
  has_many :stages, dependent: :destroy

  attr_accessor :current_password

  validates :password, presence: { if: :current_password },
            length: { minimum: 4, maximum: 16, allow_blank: true },
            format: {  with: /\A[0-9A-Za-z]*\z/, allow_blank: true,
                       message: :invalid_actor_pass
            }
  validates :name, presence: true,
            length: { minimum: 2, maximum: 20, allow_blank: true },
            uniqueness: true
  validates :login_name, presence: true,
            length: { minimum: 4, maximum: 16, allow_blank: true },
            format: {  with: /\A[0-9A-Za-z]*\z/, allow_blank: true,
                       message: :invalid_actor_login
            },
            uniqueness: true

end
