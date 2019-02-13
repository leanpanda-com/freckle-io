module FreckleIO
  module Client
    class Projects
      PROJECT_ENDPOINT = "/v2/projects".freeze
      ALLOWED_KEYS = %i(
        name
        project_group_ids
        billing_increment
        enabled
        billable
        per_page
      ).freeze
      VALIDATOR_MODULE = "FreckleIO::Validator::Project".freeze

      def all(params = {})
        multiple_pages.get(PROJECT_ENDPOINT, params: project_params(params))
      end

      def show(id)
        single_page.get("#{PROJECT_ENDPOINT}/#{id}")
      end

      private

      def multiple_pages
        @multiple_pages ||= Request::MultiplePages.new
      end

      def single_page
        @single_page ||= Request::SinglePage.new
      end

      def project_params(params)
        @project_params = Params.new(
          params,
          ALLOWED_KEYS,
          VALIDATOR_MODULE
        ).call
      end
    end
  end
end
