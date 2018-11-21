module FreckleIO
  module Validator
    module User
      # rubocop:disable Metrics/MethodLength,
      # rubocop:disable Metrics/AbcSize,
      # rubocop:disable Lint/NestedMethodDefinition
      def self.validation(params, valid_keys)
        Dry::Validation.Schema do
          configure do
            config.messages_file = "lib/freckle_io/validator/validation.yml"
            config.namespace = :user

            predicates(RestrictedHash)

            option :allowed_keys

            def valid_roles
              %w(supervisor leader coworker contractor)
            end

            def valid_states
              %w(disabled pending active suspended)
            end
          end

          restricted_hash?(allowed_keys) do
            optional(:name).filled :str?
            optional(:email).filled :str?
            optional(:email).value(format?: /\A[^@\s]+@[^@\s]+\z/)
            optional(:role).value(included_in?: valid_roles)
            optional(:state).value(included_in?: valid_states)
          end
        end.with(allowed_keys: valid_keys).call(params)
      end
      # rubocop:enable Metrics/MethodLength,
      # rubocop:enable Metrics/AbcSize,
      # rubocop:enable Lint/NestedMethodDefinition
    end
  end
end
