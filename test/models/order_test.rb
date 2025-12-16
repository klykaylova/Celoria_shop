require "test_helper"

class OrderTest < ActiveSupport::TestCase
  test "замовлення валідне" do
    order = Order.new(
      name: "Test",
      address: "Street 1",
      phone: "380501112233",
      delivery_method: "nova_poshta",
      payment_method: "card"
    )

    assert order.valid?
  end

  test "enum статуси працюють" do
    order = Order.new
    order.status = "confirmed"
    assert_equal "confirmed", order.status
  end
end