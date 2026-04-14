class Order < ApplicationRecord
  belongs_to :user, optional: true
  has_many :order_items, dependent: :destroy

  enum :status, {
    new: "new",
    paid: "paid",
    confirmed: "confirmed",
    shipped: "shipped",
    delivered: "delivered",
    cancelled: "cancelled",
    refunded: "refunded"
  }, prefix: true

  # 🔥 СТАТУСИ
  ALLOWED_TRANSITIONS = {
    "new" => ["paid", "cancelled"],

    "paid" => ["confirmed"],

    "confirmed" => ["shipped"],

    "shipped" => ["delivered"],

    "delivered" => [],

    "cancelled" => [],

    "refunded" => []
  }

  def can_transition_to?(new_status)
    ALLOWED_TRANSITIONS[status]&.include?(new_status)
  end

  def paid?
    ["paid", "confirmed", "shipped", "delivered"].include?(status)
  end

  def user_can_cancel?
    ["new", "paid"].include?(status)
  end

  def cancel_by_user!
    if status == "paid"
      update!(status: "refunded")
    elsif status == "new"
      update!(status: "cancelled")
    else
      raise "Неможливо скасувати"
    end
  end
end