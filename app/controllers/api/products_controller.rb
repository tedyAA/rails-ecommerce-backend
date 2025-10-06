module Api
  class ProductsController < ApplicationController
    include Rails.application.routes.url_helpers

    def index
      products = Product.includes(:category, :type, images_attachments: :blob)

      products = products.where(bestseller: params[:bestseller] == "true") if params[:bestseller].present?
      products = products.where(category_id: params[:category].split(',').map(&:to_i)) if params[:category].present?
      products = products.where(type_id: params[:type].split(',').map(&:to_i)) if params[:type].present?

      if params[:term].present?
        term = params[:term].downcase
        products = products.where("LOWER(name) LIKE ?", "%#{term}%")
      end

      products = products.order(Arel.sql('RANDOM()')) if params[:random] == "true"

      if params[:sort].present?
        case params[:sort]
        when "high-low"
          products = products.order(price: :desc)
        when "low-high"
          products = products.order(price: :asc)
        else
        
        end
      end

      page = (params[:page] || 1).to_i
      per_page = (params[:per] || 12).to_i
      offset = (page - 1) * per_page

      total_count = products.count
      products = products.offset(offset).limit(per_page)

      render json: {
        current_page: page,
        total_pages: (total_count.to_f / per_page).ceil,
        total_count: total_count,
        products: products.map do |product|
          {
            **product.attributes.symbolize_keys,
            category: product.category,
            type: product.type,
            image_urls: product.images.map { |img| url_for(img) }
          }
        end
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
