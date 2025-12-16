class AddCharacteristicsToProducts < ActiveRecord::Migration[8.1]
  def change
    add_column :products, :characteristics, :json
  end
end
