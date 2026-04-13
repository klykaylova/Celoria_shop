class ContactsController < ApplicationController

def index
  redirect_to new_contact_path
end

  def new
    @feedback = Feedback.new
  end

  def create
  @feedback = Feedback.new(feedback_params)

  if current_user
    @feedback.user = current_user
    @feedback.name = current_user.name
    @feedback.email = current_user.email
  end

  if @feedback.save
    redirect_to contacts_path, notice: "Ваше повідомлення надіслано! 💚"
  else
    flash.now[:alert] = "Повідомлення не може бути порожнім."
    render :new, status: :unprocessable_entity
  end
end

  private

  def feedback_params
  params.require(:feedback).permit(:name, :email, :message)
  end
end