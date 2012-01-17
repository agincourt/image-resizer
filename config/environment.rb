RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.time_zone = 'London'
  # gems
  config.gem 'SystemTimer', :lib => 'system_timer'
  config.gem 'paperclip', :lib => 'paperclip'
  config.gem 'haml'
  # we don't want active resource
  config.frameworks -= [:active_resource]
end