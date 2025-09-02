# app/controllers/api/users_controller.rb
module Api
  class UsersController < ApplicationController
    skip_before_action :verify_authenticity_token

    def create
      user = User.new(user_params)
      if user.save
        render json: { user: user }, status: :created
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :phone, :password)
    end
  end
end
