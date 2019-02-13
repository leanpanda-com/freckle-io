module Anonymize
  class Tags
    attr_accessor :interaction
    TAG_API_REPLACE_VALUES = {
      id: /\"id\":(.*?),/mi,
      name: /\"name\":\"(.*?)\"/mi,
      formatted_name: /\"formatted_name\":\"(.*?)\"/mi,
      url: /\"url\":\"(.*?)\"/mi
    }.freeze

    def initialize(interaction:)
      @interaction = interaction
    end

    def call
      find_and_replace
    end

    private

    def find_and_replace
      TAG_API_REPLACE_VALUES.each do |key, regex|
        match_texts = interaction.response.body.scan(regex)

        match_texts.each_with_index do |text, index|
          replace = anonymize_response_value(key, index)
          interaction.filter!(text.first, replace)
        end
      end

      interaction
    end

    def anonymize_response_value(key, index)
      return "http://foo.com/#{index}" if key.to_s.include? "url"

      case key
      when :id
        index.to_s
      when :mail
        "#{key}_#{index}@domain.com"
      else
        "#{key}_#{index}"
      end
    end
  end
end
