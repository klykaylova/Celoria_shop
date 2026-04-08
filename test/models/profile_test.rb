require "test_helper"

class ProfileTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(
      name: "Profile User",
      email: "profile_user@example.com",
      password: "password123"
    )
  end

  test "профіль валідний при наявності користувача" do
    profile = Profile.new(
      user: @user,
      address: nil,
      phone: nil
    )

    assert profile.valid?
  end
end