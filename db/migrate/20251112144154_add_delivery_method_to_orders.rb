class AddDeliveryMethodToOrders < ActiveRecord::Migration[8.1]
  def change
    add_column :orders, :delivery_method, :string
  end
end
