module Api
  class OrdersController < ApplicationController
    before_action :authenticate_user!

    def create
      ActiveRecord::Base.transaction do
        cart = find_cart_for_current_user(params[:cart_id])
        raise ActiveRecord::RecordNotFound unless cart

        order = current_user.orders.create!(
          cart: cart,
          address: order_params[:address],
          payment_method: order_params[:payment_method]
        )

        cart.cart_items.find_each do |ci|
          order.order_items.create!(
            product: ci.product,
            quantity: ci.quantity,
            price_cents: ci.product.price
          )
        end

        order.calculate_total!
        cart.cart_items.destroy_all

        render json: order_as_json(order), status: :created
      end
    rescue ActiveRecord::RecordInvalid => e
      render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Cart not found or not yours" }, status: :not_found
    end

    def show
      order = current_user.orders.find(params[:id])
      render json: order_as_json(order)
    end

    private

    def order_params
      params.permit(:cart_id, :address, :payment_method)
    end

    def find_cart_for_current_user(cart_id)
      return current_user.cart if cart_id.blank?
      cart = Cart.find_by(id: cart_id)
      cart if cart && cart.user_id == current_user.id
    end

    def order_as_json(order)
      order.as_json(
        only: [:id, :total_cents, :status, :address, :payment_method, :created_at],
        include: { order_items: { include: :product } }
      )
    end
  end
end
