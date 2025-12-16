class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?, :admin?

  # -------------------------
  # Поточний користувач
  # -------------------------
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    current_user.present?
  end

  def admin?
    logged_in? && current_user.admin?
  end

  # -------------------------
  # Вхід обов'язковий (для замовлень)
  # -------------------------
  def require_login
    unless logged_in?
      redirect_to login_path, alert: "Спочатку увійдіть у акаунт."
    end
  end

  # -------------------------
  # Тільки адмін (для адмін-панелі)
  # -------------------------
  def require_admin
    unless admin?
      redirect_to root_path, alert: "Доступ заборонено!"
    end
  end

  # -------------------------
  # Перенесення кошика гостя після входу
  # -------------------------
  def merge_guest_cart_into_user_cart
    return unless session[:cart]
    return unless current_user

    guest_cart = session[:cart]["guest"]
    return unless guest_cart

    user_key = current_user.id.to_s
    session[:cart][user_key] ||= {}

    guest_cart.each do |product_id, qty|
      session[:cart][user_key][product_id] =
        (session[:cart][user_key][product_id] || 0) + qty.to_i
    end

    # видалення гостьового кошика
    session[:cart].delete("guest")
  end
end

