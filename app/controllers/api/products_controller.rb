module Api
  class ProductsController < ApplicationController
    include Rails.application.routes.url_helpers  # Needed for url_for

    def index
      products = Product.includes(:category, :type, images_attachments: :blob).all
      products = products.where(bestseller: true) if params[:bestseller] == "true"

       if params[:per].present?
        per = params[:per].to_i
        products = products.limit(per) if per > 0
       end

      render json: products.map { |product|
        product_attributes = product.attributes
        product_attributes[:category] = product.category
        product_attributes[:type] = product.type
        product_attributes[:image_urls] = product.images.map { |img| url_for(img) } # multiple images
        product_attributes
      }
    end

    def show
      product = Product.includes(:category, images_attachments: :blob).find_by(id: params[:id])
      if product
        product_attributes = product.attributes
        product_attributes[:category] = product.category
        product_attributes[:image_urls] = product.images.map { |img| url_for(img) } # multiple images
        render json: product_attributes
      else
        render json: { error: "Product not found" }, status: :not_found
      end
    end
  end
end