class ApplicationController < ActionController::Base
  def authenticate_user!
    render json: { error: "Not authenticated" }, status: :unauthorized unless current_user
  end

  def current_user
    return @current_user if defined?(@current_user)

    token = request.headers["Authorization"]&.split(" ")&.last
    return nil unless token

    begin
      decoded = JWT.decode(token, Rails.application.secrets.secret_key_base)[0]
      @current_user = User.find_by(id: decoded["user_id"])
    rescue JWT::DecodeError
      nil
    end
  end
end
