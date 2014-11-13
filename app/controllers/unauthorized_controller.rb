class UnauthorizedController < ActionController::Metal
  include ActionController::UrlFor
  include ActionController::Rendering
  include Rails.application.routes.url_helpers
  include Rails.application.routes.mounted_helpers

  delegate :flash, :to => :request

  def self.call(env)
    @respond ||= action(:respond)
    @respond.call(env)
  end

  def respond
    self.status = 404
    self.response_body = {}.to_json
  end
end 
