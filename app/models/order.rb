class Order < ApplicationRecord
  belongs_to :user, optional: true
  has_many :order_items, dependent: :destroy

  # Статуси
  enum :status, {
    new:              "new",              # нове замовлення
    confirmed:        "confirmed",        # підтверджене адміном
    paid:             "paid",             # оплачене
    shipped:          "shipped",          # відправлене
    delivered:        "delivered",        # доставлене
    cancelled:        "cancelled",        # скасоване
    refunded:         "refunded"          # повернення коштів
  }, prefix: true
end

