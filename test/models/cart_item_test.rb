require "test_helper"

class CartItemTest < ActiveSupport::TestCase
  fixtures :carts, :products, :cart_items

  test "елемент кошика валідний при наявності cart і product" do
    item = cart_items(:one)
    assert item.valid?
  end

  test "невалідний без cart" do
    item = CartItem.new(product_id: products(:one).id, quantity: 1)
    assert_not item.valid?
  end

  test "невалідний без product" do
    item = CartItem.new(cart_id: carts(:one).id, quantity: 1)
    assert_not item.valid?
  end
end