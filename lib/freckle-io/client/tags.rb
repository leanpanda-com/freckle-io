module FreckleIO
  module Client
    class Tags
      TAG_ENDPOINT = "/v2/tags".freeze
      ALLOWED_KEYS = %i(name billable per_page).freeze
      VALIDATOR_MODULE = "FreckleIO::Validator::Tag".freeze

      def all(params = {})
        multiple_pages.get(TAG_ENDPOINT, params: tag_params(params))
      end

      # not implemented
      #
      # def show(id)
      #   single_page.get("#{TAG_ENDPOINT}/#{id}")
      # end

      private

      def multiple_pages
        @multiple_pages ||= Request::MultiplePages.new
      end

      def tag_params(params)
        @tag_params = Params.new(
          params,
          ALLOWED_KEYS,
          VALIDATOR_MODULE
        ).call
      end
    end
  end
end
