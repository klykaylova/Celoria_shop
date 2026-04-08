class AddReplyToFeedbacks < ActiveRecord::Migration[8.1]
  def change
    add_column :feedbacks, :reply, :text
  end
end
