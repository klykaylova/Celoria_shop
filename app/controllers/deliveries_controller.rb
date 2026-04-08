class DeliveriesController < ApplicationController
  before_action :set_order
  before_action :set_delivery, only: [:show, :edit, :update, :destroy]

  def new
    @delivery = @order.build_delivery
  end

  def create
    @delivery = @order.build_delivery(delivery_params)
    if @delivery.save
      redirect_to order_delivery_path(@order, @delivery), notice: "🚚 Доставка створена!"
    else
      render :new, alert: "Не вдалося створити доставку."
    end
  end

  def show
  end

  def edit
  end

  def update
    if @delivery.update(delivery_params)
      redirect_to order_delivery_path(@order, @delivery), notice: "✅ Дані доставки оновлено!"
    else
      render :edit, alert: "Не вдалося оновити доставку."
    end
  end

  def destroy
    @delivery.destroy
    redirect_to @order, notice: "🗑️ Доставку видалено!"
  end

  private

  def set_order
    @order = Order.find(params[:order_id])
  end

  def set_delivery
    @delivery = @order.delivery
  end

  def delivery_params
    params.require(:delivery).permit(:address, :delivery_date, :status)
  end
end