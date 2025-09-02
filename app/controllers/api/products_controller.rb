module Api
  class ProductsController < ApplicationController
    include Rails.application.routes.url_helpers

    def index
      products = Product.includes(:category, :type, images_attachments: :blob)

      products = products.where(bestseller: params[:bestseller] == "true") if params[:bestseller].present?
      products = products.where(category_id: params[:category].split(',').map(&:to_i)) if params[:category].present?
      products = products.where(type_id: params[:type].split(',').map(&:to_i)) if params[:type].present?
      products = products.limit(params[:per].to_i) if params[:per].present? && params[:per].to_i > 0
      if params[:term].present?
       term = params[:term].downcase
       products = products.where("LOWER(name) LIKE ?", "%#{term}%")
      end

      render json: products.map { |product|
        product_attributes = product.attributes
        product_attributes[:category] = product.category
        product_attributes[:type] = product.type
        product_attributes[:image_urls] = product.images.map { |img| url_for(img) }
        product_attributes
      }
    end

    def show
      product = Product.includes(:category, images_attachments: :blob).find_by(id: params[:id])
      if product
        product_attributes = product.attributes
        product_attributes[:category] = product.category
        product_attributes[:image_urls] = product.images.map { |img| url_for(img) }
        render json: product_attributes
      else
        render json: { error: "Product not found" }, status: :not_found
      end
    end
  end
end
