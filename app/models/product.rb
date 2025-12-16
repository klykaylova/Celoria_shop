class Product < ApplicationRecord
  belongs_to :category  

  has_many_attached :images
  has_many :reviews, dependent: :destroy

  attribute :characteristics, :json, default: {}
end