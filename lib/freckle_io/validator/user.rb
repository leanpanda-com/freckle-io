module FreckleIO
  module Validator
    class User < FreckleIO::Validator::BaseContract
      schema do
        optional(:name).filled(:string)
        optional(:email).filled(:string)
        optional(:per_page).filled(:integer)
        optional(:role).value(
          included_in?: %w(supervisor leader coworker contractor)
        )
        optional(:state).value(
          included_in?: %w(disabled pending active suspended)
        )
      end

      rule(:email).validate(:email_format)
    end
  end
end
