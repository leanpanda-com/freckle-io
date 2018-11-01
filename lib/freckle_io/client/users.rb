module FreckleIO
  module Client
    class Users
      USER_ENDPOINT = "/v2/users".freeze

      def all(params: {})
        multiple_pages.get(USER_ENDPOINT, params: params)
      end

      def show(id)
        single_page.get("#{USER_ENDPOINT}/#{id}")
      end

      private

      def single_page
        @single_page ||= FreckleIO::Request::SinglePage.new
      end

      def multiple_pages
        @multiple_pages ||= FreckleIO::Request::MultiplePages.new
      end
    end
  end
end
