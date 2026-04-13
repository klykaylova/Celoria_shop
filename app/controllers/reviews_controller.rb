class ReviewsController < ApplicationController
  def create
    @product = Product.find(params[:product_id])
    @review = @product.reviews.new(review_params)
    @review.user = current_user

    if @review.save
      redirect_to @product, notice: "Ваш відгук додано!"
    else
      redirect_to @product, alert: "Будь ласка, заповніть всі поля."
    end
  end

  private

  def review_params
    params.require(:review).permit(:rating, :comment)
  end
end