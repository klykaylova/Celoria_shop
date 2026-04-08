class User < ApplicationRecord
  has_secure_password

  has_many :reviews, dependent: :destroy
  has_many :orders, dependent: :nullify
  has_many :feedbacks, dependent: :destroy
  has_one :profile, dependent: :destroy

  validates :name, presence: true

  validates :email,
          presence: true,
          uniqueness: { case_sensitive: false, message: "вже використовується" },
          format: { with: URI::MailTo::EMAIL_REGEXP, message: "некоректний формат email" }

  # 🔥 ДОДАЛИ
  after_create :create_profile

  before_save :set_default_role

  def admin?
    role == "admin"
  end

  private

  def set_default_role
    self.role ||= "user"
  end

  # 🔥 ОСНОВНЕ
  def create_profile
    build_profile.save
  end
end