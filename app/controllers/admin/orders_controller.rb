class Admin::OrdersController < ApplicationController
  layout "admin"

  before_action :require_admin
  before_action :set_order, only: [:show, :edit, :update_status, :destroy]

  # =========================
  # INDEX + FILTER
  # =========================
  def index
    @orders = Order.order(created_at: :desc)

    if params[:status].present?
      @orders = @orders.where(status: params[:status])
    end
  end

  # =========================
  # SHOW
  # =========================
  def show
  end

  # =========================
  # EDIT (опційно)
  # =========================
  def edit
  end

  # =========================
  # UPDATE STATUS
  # =========================
  def update_status
    new_status = params[:order]&.[](:status)

    unless new_status.present?
      return redirect_back fallback_location: admin_orders_path,
                           alert: "Статус не вибрано!"
    end

    # ❌ НЕ ДОЗВОЛЯЄМО ДІЇ БЕЗ ОПЛАТИ
    if ["confirmed", "shipped", "delivered"].include?(new_status) && !@order.paid?
      return redirect_back fallback_location: admin_orders_path,
                           alert: "❌ Замовлення не оплачено"
    end

    # ❌ перевірка переходу
    unless @order.can_transition_to?(new_status)
      return redirect_back fallback_location: admin_orders_path,
                           alert: "❌ Недопустима зміна статусу"
    end

    # ✅ оновлення
    if @order.update(status: new_status)
      redirect_back fallback_location: admin_orders_path,
                    notice: "Статус оновлено!"
    else
      redirect_back fallback_location: admin_orders_path,
                    alert: "Помилка оновлення статусу"
    end
  end

  # =========================
  # DELETE
  # =========================
  def destroy
    if deletable_order?(@order)
      @order.destroy
      redirect_to admin_orders_path, notice: "Замовлення видалено!"
    else
      redirect_to admin_orders_path,
                  alert: "Видаляти можна лише завершені або скасовані замовлення!"
    end
  end

  private

  # =========================
  # HELPERS
  # =========================
  def set_order
    @order = Order.find(params[:id])
  end

  def require_admin
    unless current_user&.admin?
      redirect_to root_path, alert: "Доступ заборонено!"
    end
  end

  def deletable_order?(order)
    order.status_cancelled? || order.status_refunded? || order.status_delivered?
  end
end