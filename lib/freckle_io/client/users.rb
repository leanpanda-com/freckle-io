module FreckleIO
  module Client
    class Users
      USER_ENDPOINT = "/v2/users".freeze

      def all
        single_page.get(USER_ENDPOINT)
      end

      def show(id)
        single_page.get("#{USER_ENDPOINT}/#{id}")
      end

      private

      def single_page
        @single_page = FreckleIO::Request::SinglePage.new
      end
    end
  end
end
