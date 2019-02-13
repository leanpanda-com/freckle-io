module FreckleIO
  module Client
    class ProjectGroups
      PROJECT_GROUPS_ENDPOINT = "/v2/project_groups".freeze
      ALLOWED_KEYS = %i(name project_ids per_page).freeze
      VALIDATOR_MODULE = "FreckleIO::Validator::ProjectGroup".freeze

      def all(params = {})
        multiple_pages.get(
          PROJECT_GROUPS_ENDPOINT,
          params: project_groups_params(params)
        )
      end

      # not implemented
      #
      # def show(id)
      #   single_page.get("#{PROJECT_GROUPS_ENDPOINT}/#{id}")
      # end

      private

      def multiple_pages
        @multiple_pages ||= Request::MultiplePages.new
      end

      def project_groups_params(params)
        @project_groups_params = Params.new(
          params,
          ALLOWED_KEYS,
          VALIDATOR_MODULE
        ).call
      end
    end
  end
end
