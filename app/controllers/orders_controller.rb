class OrdersController < ApplicationController
  before_action :require_login, only: [:index, :new, :create, :show, :pay, :cancel_order]
  before_action :load_cart, only: [:new, :create]

  def index
    @orders = Order.where(user_id: current_user.id).order(created_at: :desc)
  end

  def new
    @order = Order.new
    @cart_items = []

    @cart.each do |product_id, quantity|
      product = Product.find_by(id: product_id)
      next unless product

      @cart_items << { product: product, quantity: quantity }
    end

    redirect_to cart_path, alert: "Ваш кошик порожній." if @cart_items.empty?
  end

  def create
    if @cart.blank?
      redirect_to cart_path, alert: "Ваш кошик порожній."
      return
    end

    @order = Order.new(order_params)
    @order.status = :new
    @order.total = calculate_total
    @order.user = current_user

    if @order.save
      @cart.each do |product_id, quantity|
        product = Product.find_by(id: product_id)
        next unless product

        @order.order_items.create(
          product: product,
          quantity: quantity,
          price: product.price
        )
      end

      key = current_user.id.to_s
      session[:cart][key] = {}

      redirect_to @order, notice: "✅ Замовлення створене!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @order = Order.find(params[:id])

    if @order.user_id != current_user.id && !admin?
      redirect_to root_path, alert: "❌ Немає доступу"
      return
    end

    @order_items = @order.order_items
  end

  def pay
    @order = Order.find(params[:id])

    if @order.user_id != current_user.id && !admin?
      redirect_to root_path, alert: "❌ Немає доступу"
      return
    end

    if @order.status_new? || @order.status_confirmed?
      @order.update(status: :paid)
      redirect_to @order, notice: "💳 Оплачено"
    else
      redirect_to @order, alert: "❌ Не можна оплатити"
    end
  end

  def cancel_order
    @order = Order.find(params[:id])

    if @order.user_id != current_user.id && !admin?
      redirect_to root_path, alert: "❌ Немає доступу"
      return
    end

    if @order.user_can_cancel?
      @order.cancel_by_user!
      redirect_to @order, notice: "🟢 Замовлення оновлено"
    else
      redirect_to @order, alert: "❌ Не можна скасувати"
    end
  end

  private

  # 🔥 ОСНОВНЕ 
  def require_login
    unless current_user
      session[:return_to] = request.fullpath
      redirect_to login_path, alert: "Увійдіть для продовження"
    end
  end

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