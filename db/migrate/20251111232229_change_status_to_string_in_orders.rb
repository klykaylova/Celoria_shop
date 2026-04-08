class ChangeStatusToStringInOrders < ActiveRecord::Migration[7.1]
  def change
    change_column :orders, :status, :string, default: "new"
  end
end