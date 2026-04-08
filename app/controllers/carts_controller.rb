class CartsController < ApplicationController
  before_action :load_cart

  # 🛒 Показ кошика
  def show
    @cart_items = []
    @total = 0

    @cart.each do |product_id, quantity|
      product = Product.find_by(id: product_id)
      next unless product

      @cart_items << { product: product, quantity: quantity }
      @total += product.price * quantity
    end
  end

  # ➕ Додати товар
  def add
    product_id = params[:product_id].to_s
    @cart[product_id] ||= 0
    @cart[product_id] += 1

    save_cart
    redirect_to cart_path, notice: "👜 Товар додано!"
  end

  # 🔄 Оновити кількість
  def update
    product_id = params[:product_id].to_s
    qty = params[:quantity].to_i

    if qty > 0
      @cart[product_id] = qty
    else
      @cart.delete(product_id)
    end

    save_cart
    redirect_to cart_path
  end

  # 🗑 Видалити товар
  def remove
    @cart.delete(params[:product_id].to_s)
    save_cart
    redirect_to cart_path, notice: "🗑 Видалено!"
  end

  # 🧹 Очистити кошик
  def clear
    key = current_user ? current_user.id.to_s : "guest"
    session[:cart][key] = {}

    redirect_to cart_path, notice: "🧹 Кошик очищено!"
  end

  private

  def load_cart
    session[:cart] ||= {}   # ← НЕ скидати кошик кожного разу!

    key = current_user ? current_user.id.to_s : "guest"

    session[:cart][key] ||= {}
    @cart = session[:cart][key]
  end

  def save_cart
    key = current_user ? current_user.id.to_s : "guest"
    session[:cart][key] = @cart
  end
end