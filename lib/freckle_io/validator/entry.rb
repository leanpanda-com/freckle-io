module FreckleIO
  module Validator
    class Entry < FreckleIO::Validator::BaseContract
      schema do
        optional(:user_ids).filled(:string)
        optional(:description).filled(:string)
        optional(:project_ids).filled(:string)
        optional(:tag_ids).filled(:string)
        optional(:tag_filter_type).filled(:string)
        optional(:invoice_ids).filled(:string)
        optional(:import_ids).filled(:string)
        optional(:from).filled(:string)
        optional(:to).filled(:string)
        optional(:invoiced).filled(:bool)
        optional(:invoiced_at_from).filled(:string)
        optional(:invoiced_at_to).filled(:string)
        optional(:updated_from).filled(:string)
        optional(:updated_to).filled(:string)
        optional(:billable).filled(:bool)
        optional(:approved_at_from).filled(:string)
        optional(:approved_at_to).filled(:string)
        optional(:approved_by_ids).filled(:string)
        optional(:per_page).filled(:integer)
      end

      rule(:tag_filter_type) do
        if !value.nil? && !["and", "combination of"].include?(value)
          key.failure(:invalid_tag_filter_type)
        end
      end
    end
  end
end
