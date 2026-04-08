require "test_helper"

class ProductTest < ActiveSupport::TestCase
  setup do
    @category = Category.create!(name: "Test Category")
  end

  test "товар валідний при наявності категорії" do
    product = Product.new(
      name: "Test Product",
      price: 100,
      description: "Some text",
      category: @category,
      characteristics: { color: "red" }
    )

    assert product.valid?
  end

  test "товар невалідний без категорії" do
    product = Product.new(
      name: "No Category Product",
      price: 50,
      description: "Test",
      category: nil
    )

    assert_not product.valid?
  end
end