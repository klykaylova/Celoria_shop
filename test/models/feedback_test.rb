require "test_helper"

class FeedbackTest < ActiveSupport::TestCase
  fixtures :feedbacks, :users

  test "відгук валідний при наявності повідомлення" do
    fb = feedbacks(:one)
    assert fb.valid?
  end

  test "відгук невалідний без повідомлення" do
    fb = Feedback.new(user: users(:one), message: "")
    assert_not fb.valid?
  end

  test "відповідь адміністратора може бути пустою" do
    fb = feedbacks(:two)
    assert fb.valid?
  end
end