module FreckleIO
  module Client
    class Entries
      ENTRY_ENDPOINT = "/v2/entries".freeze
      VALIDATOR_MODULE = "FreckleIO::Validator::Entry".freeze

      def all(params = {})
        multiple_pages.get(ENTRY_ENDPOINT, params: entry_params(params))
      end

      # not implemented
      #
      # def show(id)
      #   single_page.get("#{ENTRY_ENDPOINT}/#{id}")
      # end

      private

      def multiple_pages
        @multiple_pages ||= Request::MultiplePages.new
      end

      def entry_params(params)
        @entry_params = Params.new(params, VALIDATOR_MODULE).call
      end
    end
  end
end
