class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]

  # 👤 ПРОФІЛЬ
  def show
    # Якщо користувач дивиться свій профіль — показуємо фідбеки
    if current_user == @user
      @feedbacks = @user.feedbacks.order(created_at: :desc)
    else
      @feedbacks = []
    end
  end

  # 📝 РЕЄСТРАЦІЯ (форма)
  def new
    @user = User.new
  end

  # ✅ СТВОРЕННЯ КОРИСТУВАЧА
  def create
  @user = User.new(user_params)

  if @user.save
    session[:user_id] = @user.id

    merge_guest_cart(@user.id)

    redirect_to session.delete(:return_to) || new_order_path, notice: "Реєстрація успішна!"
  else
    render :new, status: :unprocessable_entity
  end
end

  # ✏️ РЕДАГУВАННЯ
  def edit
  end

  # 🔄 ОНОВЛЕННЯ ПРОФІЛЮ
  def update
    if @user.update(user_params)
      redirect_to profile_path, notice: "Профіль оновлено!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  # 🔍 ПОШУК КОРИСТУВАЧА
  def set_user
    @user = User.find_by(id: params[:id]) || current_user
  end

  # 🔒 ДОЗВОЛЕНІ ПАРАМЕТРИ
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def merge_guest_cart(user_id)
  return unless session[:cart] && session[:cart]["guest"]

  user_key = user_id.to_s
  guest_cart = session[:cart]["guest"]

  session[:cart][user_key] ||= {}

  guest_cart.each do |product_id, quantity|
    session[:cart][user_key][product_id] ||= 0
    session[:cart][user_key][product_id] += quantity
  end

  session[:cart].delete("guest")
end
end