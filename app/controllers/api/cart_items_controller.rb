module Api
  class CartItemsController < ApplicationController
     skip_before_action :verify_authenticity_token

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
  
  quantity = params[:cart_item][:quantity].to_i  # convert to integer

  if quantity <= 0
    cart_item.destroy
    return head :no_content
  end

  cart_item.update!(quantity: quantity)
  render json: cart_item, include: :product
end


    def destroy
      cart_item = current_user.cart.cart_items.find(params[:id])
      cart_item.destroy
      head :no_content
    end
  end
end
