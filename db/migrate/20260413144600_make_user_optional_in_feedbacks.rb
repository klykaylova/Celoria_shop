class MakeUserOptionalInFeedbacks < ActiveRecord::Migration[7.0]
  def change
    change_column_null :feedbacks, :user_id, true
  end
end