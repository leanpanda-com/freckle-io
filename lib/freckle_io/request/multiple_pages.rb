require "faraday_middleware"

module FreckleIO
  module Request
    class MultiplePages
      attr_reader :last_responses

      def get(path, params: {})
        retrieve_all_pages(path, params: params)

        self
      end

      private

      def retrieve_all_pages(path, params: {})
        merged_params = default_params.merge(params)

        @last_responses ||= client.get_in_parallel(
          path,
          2,
          total_pages(path, params: merged_params),
          params: merged_params
        )

        @last_responses.prepend([@first_response])
        @last_responses.flatten!
      end

      def total_pages(path, params: {})
        @total_pages ||= first_page(path, params: params).total_pages
      end

      def first_page(path, params: {})
        @first_page ||= first_single_page.get(
          path,
          params: params
        )
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
          per_page: 10
        }
      end
    end
  end
end
