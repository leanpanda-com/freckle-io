module Anonymize
  class Users
    attr_accessor :interaction

    # rubocop:disable Metrics/LineLength
    USER_API_REPLACE_VALUES = {
      id: /\"id\":(.*?),/mi,
      mail: /\"email\":\"(.*?)\"/mi,
      first_name: /\"first_name\":\"(.*?)\"/mi,
      last_name: /\"last_name\":\"(.*?)\"/mi,
      profile_image_url: /\"profile_image_url\":\"(.*?)\"/i,
      url: /\"url\":\"(.*?)\"/mi,
      entries_url: /\"entries_url\":\"(.*?)\"/mi,
      expanses_url: /\"expanse_url\":\"(.*?)\"/mi,
      activate_url: /\"activate_url\":\"(.*?)\"/mi,
      deactivate_url: /\"deactivate_url\":\"(.*?)\"/mi,
      access_projects_url: /\"give_access_to_projects_url\":\"(.*?)\"/mi,
      revoke_projects_url: /\"revoke_access_to_projects_url\":\"(.*?)\"/mi,
      revoke_all_projects_url: /\"revoke_access_to_all_projects_url\":\"(.*?)\"/mi
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
      USER_API_REPLACE_VALUES.each do |key, regex|
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
