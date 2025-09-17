# app/controllers/api/users_controller.rb
module Api
  class UsersController < ApplicationController
    skip_before_action :verify_authenticity_token

   before_action :authenticate_user!, only: [:current]

def current
  
  authenticate_user! # Will automatically render 401 if not logged in

  render json: current_user.slice(:id, :first_name, :last_name, :email).merge(
    avatar_url: current_user.avatar.attached? ? url_for(current_user.avatar) : nil
  )
end


    def create
      user = User.new(user_params)
      if user.save
        render json: { user: user }, status: :created
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end

   def update_avatar
    if current_user.update(avatar: params[:avatar])
      render json: { message: "Avatar updated", avatar_url: url_for(current_user.avatar) }
    else
      render json: { error: "Failed to update avatar" }, status: :unprocessable_entity
    end
   end

    private

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :phone, :password, :avatar)
    end
  end
end
