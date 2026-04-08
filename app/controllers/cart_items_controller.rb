class CartItemsController < ApplicationController
  before_action :set_cart

  def create
    product = Product.find(params[:product_id])
    cart_item = @cart.cart_items.find_or_initialize_by(product: product)
    cart_item.quantity += 1
    cart_item.save
    redirect_to cart_path, notice: "#{product.name} додано до кошика."
  end

  def update
    cart_item = @cart.cart_items.find(params[:id])
    if cart_item.update(cart_item_params)
      redirect_to cart_path, notice: "Кількість оновлено."
    else
      redirect_to cart_path, alert: "Помилка оновлення кількості."
    end
  end

  def destroy
    cart_item = @cart.cart_items.find(params[:id])
    cart_item.destroy
    redirect_to cart_path, notice: "Товар видалено з кошика."
  end

  private

  def set_cart
    @cart = Cart.find(session[:cart_id])
  end

  def cart_item_params
    params.require(:cart_item).permit(:quantity)
  end
end