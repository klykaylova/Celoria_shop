class Review < ApplicationRecord
  belongs_to :product
  belongs_to :user, optional: true

  validates :rating, presence: true
  validates :comment, presence: true
end