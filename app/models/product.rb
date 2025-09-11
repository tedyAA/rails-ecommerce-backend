class Product < ApplicationRecord
  has_many_attached :images do |attachable|
    attachable.variant :thumb, resize_to_limit: [50, 50]
  end

  has_many :cart_items
  has_many :carts, through: :cart_items
  
  belongs_to :category
  belongs_to :type
end
