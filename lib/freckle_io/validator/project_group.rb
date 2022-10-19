module FreckleIO
  module Validator
    class ProjectGroup < FreckleIO::Validator::BaseContract
      schema do
        optional(:name).filled(:string)
        optional(:project_ids).filled(:string)
        optional(:per_page).filled(:integer)
      end
    end
  end
end
