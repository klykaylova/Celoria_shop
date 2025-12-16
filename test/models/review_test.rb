require "test_helper"

class ReviewTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(
      name: "Test User",
      email: "review_user@example.com",
      password: "password123"
    )

    @product = Product.create!(
      name: "Test Product",
      price: 100,
      category: Category.create!(name: "Test Category")
    )
  end

  test "відгук є валідним при наявності коментаря та рейтингу" do
    review = Review.new(
      user: @user,
      product: @product,
      rating: 5,
      comment: "Гарний товар"
    )

    assert review.valid?
  end

  test "відгук невалідний без коментаря" do
    review = Review.new(
      user: @user,
      product: @product,
      rating: 4,
      comment: ""
    )

    assert_not review.valid?
  end

  test "відгук невалідний без рейтингу" do
    review = Review.new(
      user: @user,
      product: @product,
      comment: "Добре"
    )

    assert_not review.valid?
  end
end