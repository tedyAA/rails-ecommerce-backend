class User < ApplicationRecord
  has_secure_password

  has_one_attached :avatar
  has_one :cart, dependent: :destroy

  validates :email, presence: true, uniqueness: true
end
