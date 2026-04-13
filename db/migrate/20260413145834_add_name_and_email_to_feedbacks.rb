class AddNameAndEmailToFeedbacks < ActiveRecord::Migration[7.0]
  def change
    add_column :feedbacks, :name, :string
    add_column :feedbacks, :email, :string
  end
end