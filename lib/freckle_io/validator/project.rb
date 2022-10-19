module FreckleIO
  module Validator
    class Project < FreckleIO::Validator::BaseContract
      schema do
        optional(:name).filled(:string)
        optional(:project_group_ids).filled(:string)
        optional(:billing_increment).filled(:string)
        optional(:enabled).filled(:bool)
        optional(:billable).filled(:bool)
        optional(:per_page).filled(:integer)
      end

      rule(:billing_increment) do
        if value != nil && !%w(1 5 6 10 15).include?(value)
          key.failure(:invalid_billing_increment)
        end
      end
    end
  end
end
