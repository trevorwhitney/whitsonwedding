module Api
  class UsersController < ApplicationController
    skip_before_filter :authenticate!

    def new
      p params
      user = User.new(params.permit(:email, :password))
      user.save
      render json: user, status: 200
    end
  end
end
