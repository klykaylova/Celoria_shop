class AddPostcodeToOrders < ActiveRecord::Migration[8.1]
  def change
    add_column :orders, :postcode, :string
  end
end
