class Payment < ApplicationRecord
  belongs_to :order
  validates :payment_type, presence: true
end
