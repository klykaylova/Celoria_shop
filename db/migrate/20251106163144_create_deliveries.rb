class CreateDeliveries < ActiveRecord::Migration[8.1]
  def change
    create_table :deliveries do |t|
      t.references :order, null: false, foreign_key: true
      t.string :address
      t.string :status

      t.timestamps
    end
  end
end
