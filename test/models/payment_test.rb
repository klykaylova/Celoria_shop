require "test_helper"

class PaymentTest < ActiveSupport::TestCase
  setup do
    @order = Order.create!(
      name: "Order 1",
      address: "Some street",
      phone: "380501112233",
      postcode: "76000",
      delivery_method: "nova_poshta",
      payment_method: "card",
      status: "new",
      total: 150.00,
      user: User.create!(
        name: "Test User",
        email: "test_payment@example.com",
        password: "123456"
      )
    )
  end

  test "платіж валідний при наявності замовлення та типу оплати" do
    payment = Payment.new(
      order: @order,
      payment_type: "card",
      amount: 150.00
    )

    assert payment.valid?
  end

  test "платіж невалідний без типу оплати" do
    payment = Payment.new(
      order: @order,
      payment_type: nil
    )

    assert_not payment.valid?
  end

  test "платіж невалідний без замовлення" do
    payment = Payment.new(
      order: nil,
      payment_type: "card"
    )

    assert_not payment.valid?
  end
end