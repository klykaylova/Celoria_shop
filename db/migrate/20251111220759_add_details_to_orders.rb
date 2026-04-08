class AddDetailsToOrders < ActiveRecord::Migration[8.1]
  def change
    add_column :orders, :name, :string
    add_column :orders, :address, :string
    add_column :orders, :phone, :string
  end
end
