require "faraday_middleware"

module FreckleIO
  module Request
    class MultiplePages
      attr_reader :last_responses

      def get(path)
        retrieve_all_pages(path)

        self
      end

      private

      def retrieve_all_pages(path)
        @last_responses ||= client.get_in_parallel(
          path,
          2,
          total_pages(path),
          default_params
        )

        @last_responses.prepend([@first_response])
        @last_responses.flatten!
      end

      def total_pages(path)
        @total_pages ||= first_page(path).total_pages
      end

      def first_page(path)
        @first_page ||= first_single_page.get(path, default_params)
        @first_response = @first_page.last_response

        @first_page
      end

      def first_single_page
        @first_single_page ||= FreckleIO::Request::SinglePage.new
      end

      def client
        @client ||= FreckleIO::Connection.new
      end

      def default_params
        {
          params: {
            per_page: 10
          }
        }
      end
    end
  end
end
