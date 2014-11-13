class ApiController < ApplicationController
  def protected
    render json: {message: "protected resource"}, status: 200
  end

end
