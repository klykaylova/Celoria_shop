require "test_helper"

class CartTest < ActiveSupport::TestCase
  fixtures :carts, :cart_items, :products

  test "кошик може бути створений" do
    cart = Cart.new
    assert cart.valid?, "Кошик має бути валідним без атрибутів"
  end

  test "кошик має елементи" do
    cart = carts(:one)
    assert_not cart.cart_items.empty?, "Кошик повинен мати елементи з фікстур"
  end
end