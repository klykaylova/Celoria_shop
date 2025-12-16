class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]

  def show
    # Якщо користувач зайшов у власний профіль — показуємо його фідбеки
    if current_user == @user
      @feedbacks = @user.feedbacks.order(created_at: :desc)
    else
      @feedbacks = []   # щоб не було nil
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to login_path, notice: "Реєстрація успішна!"
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to profile_path, notice: "Профіль оновлено!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find_by(id: params[:id]) || current_user
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end