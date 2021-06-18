require 'dotenv/load'
require 'simplecov'
require_relative '../spec/dummy/config/environment'
require_relative '../lib/solana_rpc_ruby'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].sort.each { |f| require f }

ENV['RAILS_ENV'] = 'test'
ENV['RAILS_ROOT'] ||= "#{File.dirname(__FILE__)}../../../spec/dummy"

if ENV['CI'] == 'true'
  require 'codecov'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end

SimpleCov.start 'rails' do
  add_filter 'spec/'
  add_filter '.github/'
  add_filter 'lib/generators/templates/'
  add_filter 'lib/solana_rpc_ruby/version'
end

RSpec.configure do |config|
  config.include FileManager
end

include FileManager
add_config
