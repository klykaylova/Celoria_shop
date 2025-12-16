module OrdersHelper
  def order_status_label(order)
    case order.status
    when "new"
      content_tag(:span, "🟡 Нове", style: "color: orange; font-weight: bold;")
    when "confirmed"
      content_tag(:span, "🟢 Підтверджене", style: "color: green; font-weight: bold;")
    when "paid"
      content_tag(:span, "💳 Оплачене", style: "color: blue; font-weight: bold;")
    when "shipped"
      content_tag(:span, "📦 Відправлене", style: "color: purple; font-weight: bold;")
    when "delivered"
      content_tag(:span, "✅ Доставлене", style: "color: green; font-weight: bold;")
    when "cancelled"
      content_tag(:span, "❌ Скасоване", style: "color: red; font-weight: bold;")
    when "refunded"
      content_tag(:span, "↩️ Повернено", style: "color: gray; font-weight: bold;")
    else
      content_tag(:span, order.status)
    end
  end
end