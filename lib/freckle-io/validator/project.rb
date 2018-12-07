module FreckleIO
  module Validator
    module Project
      # rubocop:disable Metrics/MethodLength,
      # rubocop:disable Metrics/AbcSize,
      # rubocop:disable Lint/NestedMethodDefinition
      def self.validation(params, valid_keys)
        Dry::Validation.Schema do
          configure do
            config.messages_file = File.join(
              __dir__, "validation.yml"
            )
            config.namespace = :project

            predicates(RestrictedHash)

            option :allowed_keys

            def valid_increment
              %w(1 5 6 10 15)
            end

            def valid_increment?(options, values)
              values.split(",").all? do |value|
                valid_increment.include?(value)
              end
            end
          end

          restricted_hash?(allowed_keys) do
            optional(:name).filled :str?
            optional(:project_group_ids).filled :str?
            optional(:billing_increment).filled :str?
            optional(:billing_increment).filled(valid_increment?: {})
            optional(:enabled).filled :bool?
            optional(:billable).filled :bool?
            optional(:per_page).filled :int?
          end
        end.with(allowed_keys: valid_keys).call(params)
      end
      # rubocop:enable Metrics/MethodLength,
      # rubocop:enable Metrics/AbcSize,
      # rubocop:enable Lint/NestedMethodDefinition
    end
  end
end
