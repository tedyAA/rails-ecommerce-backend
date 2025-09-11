module Api
  class CartsController < ApplicationController
    before_action :authenticate_user!

    def show
      cart = current_user.cart || current_user.create_cart

      render json: cart.as_json(
        include: {
          cart_items: {
            include: :product
          }
        }
      )
    end
  end
end
