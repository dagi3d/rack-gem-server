require 'rack/test'
require File.expand_path('../../gem_server', __FILE__)

APP_ROOT = File.expand_path('.')

RSpec.configure do |config|
  config.mock_with :rspec
  config.include Rack::Test::Methods  
end