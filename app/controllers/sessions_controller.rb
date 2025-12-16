class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id

      # 🔥 переносення товарів з гостьового кошика в кошик користувача
      merge_guest_cart_into_user_cart

      redirect_to cart_path, notice: "Ви успішно увійшли!"
    else
      flash.now[:alert] = "Невірний email або пароль."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "Ви вийшли з акаунта."
  end
end

