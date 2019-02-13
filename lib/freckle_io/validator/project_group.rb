module FreckleIO
  module Validator
    module ProjectGroup
      # rubocop:disable Metrics/MethodLength,
      # rubocop:disable Metrics/AbcSize,
      def self.validation(params, valid_keys)
        Dry::Validation.Schema do
          configure do
            config.messages_file = File.join(
              __dir__, "validation.yml"
            )
            config.namespace = :project_group

            predicates(RestrictedHash)

            option :allowed_keys
          end

          restricted_hash?(allowed_keys) do
            optional(:name).filled :str?
            optional(:project_ids).filled :str?
            optional(:per_page).filled :int?
          end
        end.with(allowed_keys: valid_keys).call(params)
      end
      # rubocop:enable Metrics/MethodLength,
      # rubocop:enable Metrics/AbcSize,
    end
  end
end
