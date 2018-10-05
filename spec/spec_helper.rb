$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib"))
$LOAD_PATH.unshift(File.dirname(__FILE__))

Dir["./spec/support/**/*.rb"].sort.each { |f| require f }

require "simplecov"
require "simplecov-console"
require "coveralls"

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(
  [
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::Console,
    Coveralls::SimpleCov::Formatter
  ]
)

SimpleCov.start do
  add_filter "spec/"
end

require "freckle_io"
require "rspec"
require "vcr"
require "webmock"
require "dotenv"

Dotenv.load(".env.test")

RSpec.configure do |config|
  config.before(:all) do
    FreckleIO.configure do |c|
      c.token = ENV["FRECKLE_TOKEN"]
      c.url = ENV["FRECKLE_URL"]
      c.auth_type = :freckle_token
    end
  end
end

VCR.configure do |c|
  c.allow_http_connections_when_no_cassette = true
  c.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  c.hook_into :webmock

  c.configure_rspec_metadata!
  c.default_cassette_options = {
    match_requests_on: [:method, :query, :body]
  }

  c.filter_sensitive_data("<TOKEN>") { filter_api_token }

  c.before_record do |interaction|
    AnonymizeInteraction.new(interaction: interaction).call
  end
end

def filter_api_token
  ENV.fetch "FRECKLE_TOKEN", "freckle_token"
end
