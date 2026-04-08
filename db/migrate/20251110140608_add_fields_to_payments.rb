class AddFieldsToPayments < ActiveRecord::Migration[7.1]
  def change
    # Додаємо лише payment_type, бо status уже є
    unless column_exists?(:payments, :payment_type)
      add_column :payments, :payment_type, :string
    end
  end
end
