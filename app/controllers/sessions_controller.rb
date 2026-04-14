class SessionsController < ApplicationController
  def new
  end

  def create
  user = User.find_by(email: params[:email])

  if user && user.authenticate(params[:password])
    session[:user_id] = user.id

    merge_guest_cart(user.id)

    redirect_to session.delete(:return_to) || new_order_path, notice: "Ви успішно увійшли!"
  else
    flash.now[:alert] = "Невірний email або пароль."
    render :new, status: :unprocessable_entity
  end
end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "Ви вийшли з акаунта."
  end

  private

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