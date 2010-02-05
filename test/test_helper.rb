ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails/test_help'
require 'shoulda'
begin
  require 'redgreen'
rescue LoadError
end

class ActiveSupport::TestCase
  fixtures :all
end
