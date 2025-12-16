class Feedback < ApplicationRecord
  belongs_to :user, optional: true

  validates :message, presence: true

  # Адмінська відповідь необов'язкова
  validates :reply, length: { maximum: 500 }
end