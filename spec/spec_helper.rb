$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require "simplecov"
require "coveralls"

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(
  [
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter
  ]
)

SimpleCov.start do
  add_filter "spec/"
end

require 'freckle_io'
require 'rspec'
require 'vcr'
require 'webmock'
require 'dotenv'
require 'pry'

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

REGEX = {
  id: /\"id\":(.*?),/mi,
  mail: /\"email\":\"(.*?)\"/mi,
  first_name: /\"first_name\":\"(.*?)\"/mi,
  last_name: /\"last_name\":\"(.*?)\"/mi,
  profile_image_url: /\"profile_image_url\":\"(.*?)\"/i,
  url: /\"url\":\"(.*?)\"/mi,
  entries_url: /\"entries_url\":\"(.*?)\"/mi,
  expanses_url: /\"expanse_url\":\"(.*?)\"/mi,
  activate_url: /\"activate_url\":\"(.*?)\"/mi,
  deactivate_url:/\"deactivate_url\":\"(.*?)\"/mi,
  access_projects_url: /\"give_access_to_projects_url\":\"(.*?)\"/mi,
  revoke_projects_url: /\"revoke_access_to_projects_url\":\"(.*?)\"/mi,
  revoke_all_projects_url: /\"revoke_access_to_all_projects_url\":\"(.*?)\"/mi
}.freeze

VCR.configure do |c|
  c.allow_http_connections_when_no_cassette = true
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock

  c.configure_rspec_metadata!
  c.default_cassette_options = {
    match_requests_on: [:method, :uri, :query, :body]
  }

  c.filter_sensitive_data('<TOKEN>') do |interaction|
    filter_api_token
  end

  c.before_record do |interaction|
    REGEX.each do |key, regex|
      match_texts = interaction.response.body.scan(regex)

      match_texts.each_with_index do |text, index|
        replace = anonimize_response_value(key, index)
        interaction.filter!(text.first, replace)
      end
    end
  end
end

def filter_api_token
  ENV.fetch 'FRECKLE_TOKEN', 'freckle_token'
end

def anonimize_response_value(key, index)
  return "http://foo.com/#{index}" if key.to_s.include? "url"

  replace ||= begin
    case key
    when :id
      "#{index}"
    when :mail
      "#{key}_#{index}@domain.com"
    else
      "#{key}_#{index}"
    end
  end
end
