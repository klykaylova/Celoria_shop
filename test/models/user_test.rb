require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "користувач валідний при наявності імені, email та паролю" do
    user = User.new(
      name: "Test User",
      email: "test@example.com",
      password: "123456"
    )
    assert user.valid?
  end

  test "користувач невалідний без email" do
    user = User.new(name: "NoEmail", password: "123456")
    assert_not user.valid?
  end
end

