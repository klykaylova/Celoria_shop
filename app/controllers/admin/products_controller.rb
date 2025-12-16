class Admin::ProductsController < ApplicationController
  layout "admin"
  before_action :require_admin
  before_action :set_product, only: [:edit, :update, :destroy]

  def index
    @products = Product.all
  end

  def new
    @product = Product.new
  end

  def create
    build_characteristics
    @product = Product.new(product_params)
    @product.characteristics = @characteristics_hash

    if @product.save
      redirect_to admin_products_path, notice: "Товар створено!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    build_characteristics
    @product.characteristics = @characteristics_hash

    if @product.update(product_params)
      redirect_to admin_products_path, notice: "Товар оновлено!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    redirect_to admin_products_path, notice: "Товар видалено!"
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  # Перетворюємо характеристики у Hash
  def build_characteristics
    keys = params[:product].delete(:characteristics_keys) || []
    values = params[:product].delete(:characteristics_values) || []

    @characteristics_hash = {}
    keys.each_with_index do |key, i|
      next if key.blank?
      @characteristics_hash[key] = values[i]
    end
  end

  def product_params
    params.require(:product).permit(
      :name,          # ← ВАЖЛИВО!
      :description,
      :price,
      :category_id,
      images: [],
      characteristics: {}
    )
  end

  def require_admin
    redirect_to root_path, alert: "Доступ заборонено!" unless current_user&.admin?
  end
end