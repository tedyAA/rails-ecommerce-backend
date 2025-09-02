module Api
  class SessionsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def create
      user = User.find_by(email: params[:email])
      if user&.authenticate(params[:password])
        token = generate_token(user.id)
        render json: { token: token, user: user }, status: :ok
      else
        render json: { error: "Invalid email or password" }, status: :unauthorized
      end
    end

    private

    def generate_token(user_id)
      payload = { user_id: user_id, exp: 24.hours.from_now.to_i }
      JWT.encode(payload, Rails.application.secrets.secret_key_base)
    end
  end
end
