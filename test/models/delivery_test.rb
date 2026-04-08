require "test_helper"

class DeliveryTest < ActiveSupport::TestCase
  fixtures :orders, :deliveries

  test "доставка валідна при наявності адреси та валідного статусу" do
    delivery = deliveries(:one)
    assert delivery.valid?
  end

  test "доставка невалідна без адреси" do
    delivery = Delivery.new(
      order: orders(:one),
      address: nil,
      status: "очікує"
    )
    assert_not delivery.valid?
  end

  test "доставка невалідна з неправильним статусом" do
    delivery = Delivery.new(
      order: orders(:one),
      address: "Test",
      status: "wrong"
    )
    assert_not delivery.valid?
  end
end