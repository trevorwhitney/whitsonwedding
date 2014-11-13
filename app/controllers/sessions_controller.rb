class SessionsController < ApplicationController
  skip_before_filter :authenticate!
  def new
    user = User.where(email: params[:email]).first
    if user.authenticate(params[:password])
      access_token = SecureRandom.uuid
      Session.create!(user_id: user.id, access_token: access_token)
      render json: {access_token: access_token}, status: 200 and return
    end

    render json: {}, status: 400
  end
end
