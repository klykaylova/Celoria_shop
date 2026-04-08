require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  fixtures :categories

  test "категорія валідна при наявності назви" do
    category = Category.new(name: "New Category")
    assert category.valid?
  end

  test "категорія невалідна без назви" do
    category = Category.new(name: nil)
    assert_not category.valid?
  end

  test "фікстура завантажується коректно" do
    cat = categories(:one)
    assert_equal "Category One", cat.name
  end
end