module FreckleIO
  module Validator
    module User
      def self.validation(params, valid_keys)
        Dry::Validation.Schema do
          configure do
            config.messages_file = "lib/freckle_io/validator/validation.yml"
            predicates(RestrictedHash)

            option :allowed_keys
          end

          restricted_hash?(allowed_keys) do
            optional(:name).filled :str?
          end
        end.with(allowed_keys: valid_keys).call(params)
      end
    end
  end
end
