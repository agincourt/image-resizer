require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Auto-require default libraries and those for the current Rails environment.
Bundler.require :default, Rails.env

module ImageEditor
  class Application < Rails::Application

    # yoo-kay
    config.time_zone = 'London'
    config.i18n.default_locale = :en

    # Configure generators values. Many other options are available, be sure to check the documentation.
    config.generators do |g|
      g.orm             :active_record
      g.template_engine :haml
      g.test_framework  :test_unit, :fixture => true
    end

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters << :password
  end
end
