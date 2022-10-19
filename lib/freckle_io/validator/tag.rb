module FreckleIO
  module Validator
    class Tag < FreckleIO::Validator::BaseContract
      schema do
        optional(:name).filled(:string)
        optional(:billable).filled(:bool)
        optional(:per_page).filled(:integer)
      end
    end
  end
end
