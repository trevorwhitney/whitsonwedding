module Api
  class ApiController < Api::ApplicationController
    def protected
      render json: {message: "protected resource"}, status: 200
    end
  end
end
