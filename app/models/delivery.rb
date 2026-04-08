class Delivery < ApplicationRecord
  belongs_to :order

  validates :address, presence: true
  validates :status, inclusion: { in: ["очікує", "в дорозі", "доставлено"] }
end
