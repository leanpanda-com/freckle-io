require "cgi"
require "uri"

class AnonymizeInteraction
  attr_reader :interaction

  PATH_TO_CLASS = [
    {
      path: %r{^\/v2\/users(\/\d+)?$},
      klass: "Anonymize::Users"},
    {
      path: %r{^\/v2\/projects(\/\d+)?$},
      klass: "Anonymize::Projects"},
    {
      path: %r{^\/v2\/entries(\/\d+)?$},
      klass: "Anonymize::Entries"},
    {
      path: %r{^\/v2\/tags(\/\d+)?$},
      klass: "Anonymize::Tags"},
    {
      path: %r{^\/v2\/project_groups(\/\d+)?$},
      klass: "Anonymize::ProjectGroups"
    }
  ].freeze

  def initialize(interaction:)
    @interaction = interaction
  end

  def call
    class_path = which_class

    if class_path
      Kernel.const_get(class_path).new(interaction: interaction).call
    else
      puts "Attention! Interaction #{request_url} isn't anonymize!"
    end
  rescue StandardError
    abort("Undefined class for #{request_url} path")
  end

  private

  def which_class
    PATH_TO_CLASS.each do |path|
      return path[:klass] if path[:path].match(request_url)
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
end
