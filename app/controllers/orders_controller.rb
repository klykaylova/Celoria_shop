class OrdersController < ApplicationController
  # замовлення доступні тільки залогіненим
  before_action :require_login, only: [:index, :new, :create, :show, :pay, :cancel_order]
  before_action :load_cart,     only: [:new, :create]

  # -------------------------
  # Список замовлень КОРИСТУВАЧА
  # -------------------------
  def index
    # тут ТІЛЬКИ замовлення поточного юзера (навіть якщо він адмін)
    @orders = Order.where(user_id: current_user.id).order(created_at: :desc)
  end

  # -------------------------
  # Нова форма оформлення
  # -------------------------
  def new
    @order = Order.new
    @cart_items = []

    @cart.each do |product_id, quantity|
      product = Product.find_by(id: product_id)
      next unless product

      @cart_items << { product: product, quantity: quantity }
    end

    if @cart_items.empty?
      redirect_to cart_path, alert: "Ваш кошик порожній."
    end
  end

  # -------------------------
  # Створення замовлення
  # -------------------------
  def create
    # якщо раптом кошик порожній
    if @cart.blank?
      redirect_to cart_path, alert: "Ваш кошик порожній."
      return
    end

    @order = Order.new(order_params)
    @order.status = :new
    @order.total  = calculate_total
    @order.user   = current_user  

    if @order.save
      @cart.each do |product_id, quantity|
        product = Product.find_by(id: product_id)
        next unless product

        @order.order_items.create(
          product:  product,
          quantity: quantity,
          price:    product.price
        )
      end

      # 🔥 очищаємо кошик тільки для поточного юзера
      key = current_user.id.to_s
      session[:cart][key] = {}

      redirect_to @order, notice: "✅ Замовлення успішно створене!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # -------------------------
  # Показ одного замовлення
  # -------------------------
  def show
    @order = Order.find(params[:id])

    # переглядати можна тільки свої замовлення
    if @order.user_id != current_user.id && !admin?
      redirect_to root_path, alert: "❌ Ви не можете переглядати це замовлення."
      return
    end

    @order_items = @order.order_items
  end

  # -------------------------
  # Оплата
  # -------------------------
  def pay
    @order = Order.find(params[:id])

    if @order.user_id != current_user.id && !admin?
      redirect_to root_path, alert: "❌ Ви не можете змінювати це замовлення."
      return
    end

    if @order.status_new? || @order.status_confirmed?
      @order.update(status: :paid)
      redirect_to @order, notice: "💳 Оплату виконано успішно!"
    else
      redirect_to @order, alert: "❌ Це замовлення зараз не можна оплатити."
    end
  end

  # -------------------------
  # Скасування
  # -------------------------
  def cancel_order
    @order = Order.find(params[:id])

    if @order.user_id != current_user.id && !admin?
      redirect_to root_path, alert: "❌ Ви не можете змінювати це замовлення."
      return
    end

    if @order.status_paid? || @order.status_shipped? || @order.status_delivered?
      new_status = :refunded
    else
      new_status = :cancelled
    end

    @order.update(status: new_status)
    redirect_to @order, notice: "🟢 Статус замовлення оновлено."
  end

  private

  # -------------------------
  # Кошик (НЕ стираємо session[:cart]!)
  # -------------------------
  def load_cart
    session[:cart] ||= {}

    key = current_user ? current_user.id.to_s : "guest"
    session[:cart][key] ||= {}

    @cart = session[:cart][key]
  end

  def calculate_total
    @cart.sum do |product_id, quantity|
      product = Product.find_by(id: product_id)
      product ? product.price * quantity.to_i : 0
    end
  end

  def order_params
    params.require(:order).permit(
      :name, :address, :phone,
      :payment_method, :delivery_method, :postcode
    )
  end
end