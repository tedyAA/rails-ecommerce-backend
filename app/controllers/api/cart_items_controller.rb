module Api
  class CartItemsController < ApplicationController
    before_action :authenticate_user!

    def create
      cart = current_user.cart || current_user.create_cart
      product = Product.find(params[:product_id])

      cart_item = cart.cart_items.find_or_initialize_by(product: product)
      cart_item.quantity = (cart_item.quantity || 0) + params[:quantity].to_i
      cart_item.save!

      render json: cart_item, include: :product
    end

    def update
      cart_item = current_user.cart.cart_items.find(params[:id])
      cart_item.update!(quantity: params[:quantity])
      render json: cart_item, include: :product
    end

    def destroy
      cart_item = current_user.cart.cart_items.find(params[:id])
      cart_item.destroy
      head :no_content
    end
  end
end
