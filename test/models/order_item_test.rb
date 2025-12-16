require "test_helper"

class OrderItemTest < ActiveSupport::TestCase
  fixtures :order_items, :orders, :products

  test "елемент замовлення валідний при наявності order і product" do
    item = order_items(:one)
    assert item.valid?
  end

  test "елемент замовлення невалідний без order" do
    item = OrderItem.new(
      product: products(:one),
      quantity: 1,
      price: 10.0
    )
    assert_not item.valid?
  end

  test "елемент замовлення невалідний без product" do
    item = OrderItem.new(
      order: orders(:one),
      quantity: 1,
      price: 10.0
    )
    assert_not item.valid?
  end
end