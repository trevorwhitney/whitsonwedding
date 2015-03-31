require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module WhitsonweddingRails
  class Application < Rails::Application
    config.time_zone = 'Mountain Time (US & Canada)'

    config.assets.paths << Rails.root.join('app', 'assets', 'fonts')
    config.assets.initialize_on_precompile = true

    Warden::Manager.serialize_into_session do |user|
      user.id
    end

    Warden::Manager.serialize_from_session do |id|
      User.find_by_id(id)
    end

    config.middleware.insert_after ActionDispatch::Flash, Warden::Manager do |manager|
      manager.failure_app = SessionsController.action(:new)
      manager.default_scope = :user

      manager.scope_defaults(
        :user, 
        strategies: [:access_token], 
        store: :false, 
      )

      manager.scope_defaults(
        :admin, 
        strategies: [:password]
      )
    end
  end
end
