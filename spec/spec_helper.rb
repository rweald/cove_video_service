require "bundler"
Bundler.setup

require "rack/test"
require "rspec"
require "mocha"
require File.expand_path(File.join(File.dirname(__FILE__), "..", 'simple_server.rb'))

ENV['RACK_ENV'] = 'test'

Rspec.configure do |config|
  config.mock_with :mocha
  config.include Rack::Test::Methods
end
