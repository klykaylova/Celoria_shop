class Admin::OrdersController < ApplicationController
  layout "admin"
  before_action :require_admin
  before_action :set_order, only: [:show, :edit, :update_status, :destroy]

  def index
    @orders = Order.order(created_at: :desc)
  end

  def show
  end

  def edit
  end

  def update_status
    if params[:order].present? && params[:order][:status].present?
      @order.update(status: params[:order][:status])
      redirect_to admin_order_path(@order), notice: "Статус оновлено!"
    else
      redirect_to admin_order_path(@order), alert: "Статус не вибрано!"
    end
  end

  def destroy
    if @order.status_cancelled? ||  @order.status_refunded? || @order.status_delivered?
      @order.destroy
      redirect_to admin_orders_path, notice: "Замовлення видалено!"
    else
      redirect_to admin_orders_path, alert: "Видаляти можна лише скасовані, повернені або доставлені!"
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def require_admin
    redirect_to root_path, alert: "Доступ заборонено!" unless current_user&.admin?
  end
end