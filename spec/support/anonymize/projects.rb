module Anonymize
  class Projects
    attr_accessor :interaction
    PROJECT_API_REPLACE_VALUES = {
      name: /\"name\":\"(.*?)\"/i,
      id: /\"id\":(.*?),/i,
      url: /\"url\":\"(.*?)\"/i,
      description: /\"description\":\"(.*?)\"/i,
      email: /\"email\":\"(.*?)\",/i,
      first_name: /\"first_name\":\"(.*?)\"/i,
      last_name: /\"last_name\":\"(.*?)\"/i,
      profile_image_url: /\"profile_image_url\":\"(.*?)\"/i
    }.freeze
    # rubocop:enable Metrics/LineLength

    def initialize(interaction:)
      @interaction = interaction
    end

    def call
      find_and_replace
    end

    private

    def find_and_replace
      response_body = interaction.response.body

      PROJECT_API_REPLACE_VALUES.each do |key, regex|
        match_texts = response_body.scan(regex).uniq
        sort_texts = sort_by_word_count(match_texts)

        sort_texts.each_with_index do |text, index|
          replace = anonymize_response_value(key, index)
          interaction.filter!(text, replace)
        end
      end

      interaction
    end

    def anonymize_response_value(key, index)
      return "http://foo.com/#{index}" if key.to_s.include? "url"

      case key
      when :id
        index.to_s
      when :email
        "#{key}_#{index}@domain.com"
      else
        "#{key}_#{index}"
      end
    end

    def sort_by_word_count(words)
      words.flatten.sort do |a, b|
        b.split.length <=> a.split.length
      end
    end
  end
end