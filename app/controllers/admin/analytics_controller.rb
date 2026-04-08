module Admin
  class AnalyticsController < ApplicationController
    before_action :require_admin

    def index
      # =========================
      # 📅 ФІЛЬТР (FIX)
      # =========================
      if params[:start_date].present? && params[:end_date].present?
        start_date = Date.parse(params[:start_date])
        end_date   = Date.parse(params[:end_date])
        @has_filter = true
      else
        start_date = Date.today
        end_date   = Date.today
        @has_filter = false
      end

      orders = Order.where(created_at: start_date.beginning_of_day..end_date.end_of_day)

      # 🔥 ВАЖЛИВО: тільки реальні (оплачені) замовлення
      paid_orders = orders.where(status: ["paid", "shipped", "delivered"])

      # =========================
      # 🔢 ОСНОВНА АНАЛІТИКА
      # =========================
      @total_revenue = paid_orders.sum(:total)
      @orders_count = orders.count
      @average_order = paid_orders.average(:total)&.round(2) || 0

      # =========================
      # 📈 ГРАФІКИ
      # =========================
      # 🔥 дохід тільки з оплачених
      @orders_by_day = paid_orders
        .group("DATE(created_at)")
        .order("DATE(created_at)")
        .sum(:total)

      # 🔹 кількість замовлень — всі
      @orders_count_by_day = orders
        .group("DATE(created_at)")
        .order("DATE(created_at)")
        .count

      # =========================
      # 🔥 GROWTH
      # =========================
      period_length = (end_date - start_date).to_i + 1

      prev_orders = Order.where(
        created_at: (start_date - period_length).beginning_of_day..(start_date - 1).end_of_day
      )

      # 🔥 також фільтруємо
      prev_paid_orders = prev_orders.where(status: ["paid", "shipped", "delivered"])

      @revenue_growth = calculate_growth(@total_revenue, prev_paid_orders.sum(:total))
      @orders_growth  = calculate_growth(@orders_count, prev_orders.count)

      # =========================
      # 🔥 ТОП ТОВАРИ
      # =========================
      top = OrderItem.joins(:order)
        .where(orders: { id: orders.select(:id) })
        .group(:product_id)
        .sum(:quantity)
        .sort_by { |_, qty| -qty }
        .first(5)

      @top_products_with_names = top.map do |product_id, quantity|
        product = Product.find_by(id: product_id)
        {
          name: product&.name || "Unknown",
          quantity: quantity
        }
      end

      # =========================
      # 🔥 ТОП КОРИСТУВАЧІ (по реальному доходу)
      # =========================
      top_users = paid_orders
        .group(:user_id)
        .sum(:total)
        .sort_by { |_, t| -t }
        .first(5)

      @top_users = top_users.map do |user_id, total|
        user = User.find_by(id: user_id)
        {
          name: user&.name || user&.email || "Unknown",
          total: total.to_i
        }
      end

      # =========================
      # 👤 НОВІ КОРИСТУВАЧІ
      # =========================
      @new_users = User.where(created_at: start_date.beginning_of_day..end_date.end_of_day).count

      # =========================
      # 📊 СТАТУСИ
      # =========================
      raw_statuses = orders.group(:status).count

      status_labels = {
        "new" => "Нові",
        "confirmed" => "Підтверджені",
        "paid" => "Оплачені",
        "shipped" => "Відправлені",
        "delivered" => "Доставлені",
        "cancelled" => "Скасовані",
        "refunded" => "Повернення"
      }

      @orders_by_status = status_labels.map do |key, label|
        {
          key: key,
          label: label,
          count: raw_statuses[key] || 0
        }
      end
    end

    private

    def calculate_growth(current, previous)
      return 0 if previous == 0
      (((current - previous).to_f / previous) * 100).round(1)
    end

    def require_admin
      redirect_to root_path, alert: "Доступ заборонено" unless current_user&.role == "admin"
    end
  end
end