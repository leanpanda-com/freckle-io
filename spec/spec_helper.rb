$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'freckle_io'
require 'rspec'
require 'vcr'
require 'webmock'
require 'dotenv'

Dotenv.load

RSpec.configure do |config|
  config.before(:all) do
    FreckleIO.configure do |c|
      c.token = ENV['FRECKLE_TOKEN']
      c.url = ENV['FRECKLE_URL']
      c.auth_type = :freckle_token
    end
  end
end

VCR.configure do |c|
  c.allow_http_connections_when_no_cassette = true
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock

  c.configure_rspec_metadata!
  c.default_cassette_options = {
    match_requests_on: [:method, :uri, :query, :body]
  }

  c.filter_sensitive_data("<TOKEN>") do |interaction|
    interaction.request.headers['X-Freckletoken']
  end
end
