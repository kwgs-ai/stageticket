class Stage < ApplicationRecord
  belongs_to :actor
  belongs_to :category
  has_many :reservations, dependent: :destroy
  has_many :seats, dependent: :destroy

  class << self
    def search(title, date, morning, afternoon)
      rel = order('id')
      if title.present?
        rel = rel.where('title LIKE ?', "%#{title}%")
      end
      if date.present?
        rel = rel.where('date LIKE ?', "%#{date}%")
      end
      if (morning.present? && afternoon.blank?) || (morning.blank? && afternoon.present?) then
        time = if morning.present? then
                 '午前'
               else
                 '午後'
               end
        rel = rel.where('time = ?', time)
      end
      rel
    end
  end
end
