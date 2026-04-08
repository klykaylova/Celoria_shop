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

  # 🔥 ПРАВИЛЬНА ЛОГІКА ПЕРЕХОДІВ
  ALLOWED_TRANSITIONS = {
    "new" => ["cancelled"],

    # 👉 після оплати
    "paid" => ["confirmed", "cancelled"],

    "confirmed" => ["shipped", "cancelled"],
    "shipped" => ["delivered"],

    "delivered" => ["refunded"],
    "cancelled" => [],
    "refunded" => []
  }

  # 🔥 перевірка переходу
  def can_transition_to?(new_status)
    ALLOWED_TRANSITIONS[status]&.include?(new_status)
  end

  # 🔥 ВИПРАВЛЕНО: чи оплачено
  def paid?
    ["paid", "confirmed", "shipped", "delivered"].include?(status)
  end

  # 👤 чи може користувач скасувати
  def user_can_cancel?
    ["new", "paid"].include?(status)
  end

  # 👤 логіка скасування
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