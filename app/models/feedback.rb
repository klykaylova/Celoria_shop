class Feedback < ApplicationRecord
  belongs_to :user, optional: true

  validates :message, presence: true

  validates :reply, length: { maximum: 500 }
end