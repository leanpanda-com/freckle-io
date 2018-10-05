require "cgi"
require "uri"

class AnonimizeInteraction
  attr_reader :interaction

  PATH_TO_CLASS = [
    {regex: %r{^\/v2\/users(\/\d+)?$}, klass: "Anonimize::Users"}
  ].freeze

  def initialize(interaction:)
    @interaction = interaction
  end

  def call
    Kernel.const_get(which_class).new(interaction: interaction).call
  rescue StandardError
    abort("No class found for #{request_url}")
  end

  private

  def which_class
    PATH_TO_CLASS.each do |path|
      return path[:klass] if path[:regex].match(request_url)
    end

    nil
  end

  def request_url
    @request_url ||= begin
      raw_uri = interaction.request.uri
      uri = URI.parse(raw_uri)

      uri.path
    end
  end

  def body
    interaction.response.body
  end
end
