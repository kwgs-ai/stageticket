class Stage < ApplicationRecord
  belongs_to :actor
  belongs_to :category
  has_many :reservations, dependent: :destroy
  has_many :seats, dependent: :destroy

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
      if title.present?
        rel = rel.where('title LIKE ?', "%#{title}%")
      end
      if date.present?
        rel = rel.where('date LIKE ?', "%#{date}%")
      end
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
