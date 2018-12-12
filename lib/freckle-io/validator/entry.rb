module FreckleIO
  module Validator
    module Entry
      # rubocop:disable Metrics/MethodLength,
      # rubocop:disable Metrics/AbcSize,
      # rubocop:disable Lint/NestedMethodDefinition
      def self.validation(params, valid_keys)
        Dry::Validation.Schema do
          configure do
            config.messages_file = File.join(
              __dir__, "validation.yml"
            )
            config.namespace = :entry

            predicates(RestrictedHash)

            option :allowed_keys

            def valid_tag_filter_type
              ["and", "combination of"]
            end
          end

          restricted_hash?(allowed_keys) do
            optional(:user_ids).filled :str?
            optional(:description).filled :str?
            optional(:project_ids).filled :str?
            optional(:tag_ids).filled :str?
            optional(:tag_filter_type).filled :str?
            optional(:tag_filter_type).value(included_in?: valid_tag_filter_type)
            optional(:invoice_ids).filled :str?
            optional(:import_ids).filled :str?
            optional(:from).filled :str?
            optional(:to).filled :str?
            optional(:invoiced).filled :bool?
            optional(:invoiced_at_from).filled :str?
            optional(:invoiced_at_to).filled :str?
            optional(:updated_from).filled :str?
            optional(:updated_to).filled :str?
            optional(:billable).filled :bool?
            optional(:approved_at_from).filled :str?
            optional(:approved_at_to).filled :str?
            optional(:approved_by_ids).filled :str?
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
