# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  skip_before_action :authenticate_request, only: [:create]

  def create
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      token = JwtService.encode(user_id: user.id)
      render json: { token: token }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end


  private

  def encode_token(payload)
    payload[:exp] = exp.to_i
    JWT.encode(payload, ENV['JWT_SECRET_KEY'], ALGORITHM)
  end
end
