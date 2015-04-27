ENV["RAILS_ENV"] ||= 'test'
require 'spec_helper'
require 'database_cleaner'
require 'capybara/webkit'
require 'capybara-screenshot/rspec'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

ActiveRecord::Migration.maintain_test_schema!

Capybara.javascript_driver = :webkit
Capybara::Screenshot.autosave_on_failure = true
Capybara::Screenshot.webkit_options = { width: 1024, height: 768  }

RSpec.configure do |config|
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, :js => true) do |example|
    DatabaseCleaner.strategy = :truncation, {pre_count: true}
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do |example|
    DatabaseCleaner.clean
    if example.exception && example.metadata[:js]
      js_errors = page.driver.error_messages
      js_messages = page.driver.console_messages

      if js_errors.present?
        print "JS Errors: "
        pp js_errors
      end

      if js_messages.present?
        print "JS Console Messages: "
        pp js_messages
      end
    end
  end
end

