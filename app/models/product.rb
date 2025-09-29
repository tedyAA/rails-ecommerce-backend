class Product < ApplicationRecord
  has_many_attached :images do |attachable|
    attachable.variant :thumb, resize_to_limit: [50, 50]
  end

  has_many :cart_items
  has_many :carts, through: :cart_items
  
  belongs_to :category
  belongs_to :type

  def image_urls
    return [] unless images.attached?

    images.map do |img|
      Rails.application.routes.url_helpers.url_for(img)
    end
  end
end
