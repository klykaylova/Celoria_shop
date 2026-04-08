class Admin::UsersController < ApplicationController
  layout "admin"
  before_action :require_admin
  before_action :set_user, only: [:edit, :update, :destroy]

  def index
    @users = User.all.order(created_at: :desc)

    if params[:query].present?
      @users = @users.where(
        "LOWER(name) LIKE :q OR LOWER(email) LIKE :q",
        q: "%#{params[:query].downcase}%"
      )
    end

    if params[:role].present?
      if params[:role] == "guest"
        @users = @users.where("role IS NULL OR role = ?", "guest")
      else
        @users = @users.where(role: params[:role])
      end
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to admin_users_path, notice: "Користувача оновлено"
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_users_path, notice: "Користувача видалено"
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :role)
  end

  def require_admin
    unless current_user&.admin?
      redirect_to root_path, alert: "Доступ заборонено!"
    end
  end
end