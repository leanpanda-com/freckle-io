module FreckleIO
  module Validator
    class BaseContract < Dry::Validation::Contract
      EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze

      config.messages.backend = :i18n
      config.messages.load_paths << File.join(__dir__, "validation.yml")

      register_macro(:email_format) do
        if value != nil && !EMAIL_REGEX.match?(value)
          key.failure(:invalid_email_format)
        end
      end
    end
  end
end
