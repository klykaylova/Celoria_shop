class Admin::DashboardController < ApplicationController
  layout "admin"
  before_action :require_admin

  def index
    @total_revenue = Order.sum(:total)
    @orders_count = Order.count
    @average_order = Order.average(:total)&.round(2)
  end
end