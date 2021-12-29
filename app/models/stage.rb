class Stage < ApplicationRecord
  belongs_to :actor
  belongs_to :category
  has_many :reservations, dependent: :destroy
  has_many :seats, dependent: :destroy

  validates :title, presence: true,
                    length: { minimum: 1, maximum: 20, allow_blank: true }
  validates :text, presence: true,
                   length: { minimum: 10, maximum: 400, allow_blank: true }
  validate do
    errors.add(:after_date, '日付が不正です') if date <= Date.today + 2
  end
  validate do
    unless Stage.where(date: date).count.zero?
      if Stage.where(date: date).count == 1
        if Stage.find_by(date: date).id == self.id
        else
          errors.add(:dable_stage, '同じ日時あり')
        end
      else
        errors.add(:dable_stage, '同じ日時あり')
      end

    end

  end

  class << self
    def search(title, date, morning, afternoon, actor, category)
      rel = order('id')
      if actor.present?
        actor = Actor.where('name LIKE ?', "%#{actor}%").ids
        rel = rel.where(actor_id: actor)
      end
      if category.present?
        category = Category.where('name LIKE ?', "%#{category}%").ids
        rel = rel.where(category_id: category)
      end
      rel = rel.where('title LIKE ?', "%#{title}%") if title.present?
      rel = rel.where('date LIKE ?', "%#{date}%") if date.present?
      if (morning.present? && afternoon.blank?) || (morning.blank? && afternoon.present?) then
        time = if morning.present? then
                 1
               else
                 2
               end
        rel = rel.where('time = ?', time)
      end
      rel
    end
  end
end
