module Api
  class SessionsController < Api::ApplicationController
    skip_before_filter :authenticate!, only: [:create]

    def create
      user = User.where(email: params['email']).first
      if user && user.authenticate(params['password'])
        access_token = SecureRandom.uuid
        Session.create!(user_id: user.id, access_token: access_token)
        response_hash = {access_token: access_token, email: user.email}
        render json: response_hash, status: 200 and return
      end

      render json: {}, status: 400
    end

    def delete
      if current_user.id
        Session.delete_all(user_id: current_user.id)
        render json: {}, status: 204 and return
      end

      render json: {}, status: 404
    end
  end
end
