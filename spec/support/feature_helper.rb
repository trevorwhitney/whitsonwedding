module FeatureHelper
  include Rack::Test::Methods

  def app
    Rails.application
  end
end

RSpec.configure do |config|
  config.include FeatureHelper, :type=>:feature #apply to all spec for apis folder
end
