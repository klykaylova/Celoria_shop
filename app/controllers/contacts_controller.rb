class ContactsController < ApplicationController

  def new
    @feedback = Feedback.new
  end

  def create
    @feedback = Feedback.new(feedback_params)
    @feedback.user_id = current_user&.id || 1

    if @feedback.save
      redirect_to contacts_path, notice: "Ваше повідомлення надіслано! 💚"
    else
      flash.now[:alert] = "Повідомлення не може бути порожнім."
      render :new, status: :unprocessable_entity
    end
  end

  private

  def feedback_params
    params.require(:feedback).permit(:message)
  end
end