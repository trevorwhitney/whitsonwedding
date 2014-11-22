module Api
  class UsersController < Api::ApplicationController
    skip_before_filter :authenticate!

    def new
      user = User.new(params.permit(:email, :password))
      user.save
      render json: user, status: 200
    end
  end
end
