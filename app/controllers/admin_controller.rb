class AdminController < ApplicationController
  before_action :require_admin

  def dashboard
  end

  private

  def require_admin
    unless admin?
      redirect_to root_path, alert: "Доступ заборонено"
    end
  end
end