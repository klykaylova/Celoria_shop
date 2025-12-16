class HomeController < ApplicationController
  def index
    @products = Product.order(created_at: :desc)
  end

  def about
  end
end
