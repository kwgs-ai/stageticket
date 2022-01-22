class Stage < ApplicationRecord
  belongs_to :actor
  belongs_to :category
  has_many :reservations, dependent: :destroy
  has_many :seats, dependent: :destroy
  validates_associated :seats

  validates :time, presence: true
  validates :title, presence: true,
            length: { minimum: 1, maximum: 20, allow_blank: true }
  validates :text, presence: true,
            length: { minimum: 10, maximum: 400, allow_blank: true }
  validate do
    errors.add(:date, 'が不正な日付です。今日から３日後以降を選択してください') if date <= Date.current.days_since(2)
  end
  validate do
    errors.add(:date, 'にはすでに承認された公演があります') if Stage.where.not(id: id).where(date: date, time: time,
status: 2).present? && (status == 2 || status == 1)
  end

  class << self
    def search(title, date, time, actor, category)
      rel = order('date').where(status: 2).where('date >= ?', Date.current)
      if actor.present?
        actor = Actor.where('name LIKE ?', "%#{actor}%").ids
        rel = rel.where(actor_id: actor)
      end
      if category.present? && category != 'なし'
        category = Category.where('name LIKE ?', "%#{category}%").ids
        rel = rel.where(category_id: category)
      end
      rel = rel.where('title LIKE ?', "%#{title}%") if title.present?
      rel = rel.where(date: date) if date.present?
      if time.present? && time != 'なし'
        time = time == '午前' ? 1 : 2
        rel = rel.where(time: time)
      end
      rel
    end
  end
end
