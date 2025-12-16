class PaymentsController < ApplicationController
  before_action :set_order

  def new
    # ініціалізуємо payment, якщо його ще немає
    @payment = @order.payment || @order.build_payment
  end

  def create
    @payment = @order.payment || @order.build_payment
    @payment.assign_attributes(payment_params)

    if @payment.payment_type == 'карткою'
      @payment.status = 'оплачено'
      @order.update(status: 'оплачено')
      flash[:notice] = '✅ Оплату здійснено карткою!'
    else
      @payment.status = 'очікує оплату'
      flash[:notice] = '💵 Оплата буде здійснена при отриманні.'
    end

    if @payment.save
      redirect_to @order
    else
      flash.now[:alert] = 'Не вдалося зберегти оплату.'
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_order
    @order = Order.find(params[:order_id])
  end

  def payment_params
    params.require(:payment).permit(:payment_type)
  end
end