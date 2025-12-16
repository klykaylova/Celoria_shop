class Admin::FeedbacksController < ApplicationController
  layout "admin"
  before_action :require_admin
  before_action :set_feedback, only: [:show, :update, :destroy]

  # ===== INDEX =====
  def index
    @feedbacks = Feedback.order(created_at: :desc)
  end

  # ===== SHOW =====
  def show
  end

  # ===== UPDATE (reply) =====
  def update
    if @feedback.update(feedback_params)
      redirect_to admin_feedback_path(@feedback), notice: "Відповідь надіслано!"
    else
      flash.now[:alert] = "Не вдалося зберегти відповідь."
      render :show
    end
  end

  # ===== DESTROY =====
  def destroy
    @feedback.destroy
    redirect_to admin_feedbacks_path, notice: "Повідомлення видалено"
  end

  # ===== PRIVATE =====
  private

  def set_feedback
    @feedback = Feedback.find(params[:id])
  end

  def feedback_params
    params.require(:feedback).permit(:reply)
  end

  def require_admin
    redirect_to root_path, alert: "Доступ заборонено!" unless current_user&.admin?
  end
end