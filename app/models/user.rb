class User < ApplicationRecord
  has_secure_password

  has_many :reviews, dependent: :destroy
  has_many :orders, dependent: :nullify
  has_many :feedbacks, dependent: :destroy

  validates :name, presence: true
  validates :name, presence: true

  validates :email,
          presence: true,
          uniqueness: { case_sensitive: false, message: "вже використовується" },
          format: { with: URI::MailTo::EMAIL_REGEXP, message: "некоректний формат email" }

  # Встановлення ролі за замовчуванням
  before_save :set_default_role

  # Перевірка, чи користувач — адміністратор
  def admin?
    role == "admin"
  end

  private

  # Якщо роль не задана — звичайний користувач
  def set_default_role
    self.role ||= "user"
  end
end

