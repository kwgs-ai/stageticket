class Category < ApplicationRecord
  has_many :stages, dependent: :destroy
end
