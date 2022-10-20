require "faraday_middleware"

module FreckleIO
  module Request
    class MultiplePages
      attr_reader :path,
                  :params,
                  :last_responses

      def get(path, params: {})
        @path ||= path
        @params ||= default_params.merge(params).compact

        retrieve_all_pages

        self
      end

      private

      def retrieve_all_pages
        @last_responses ||= client.get_in_parallel(
          path,
          2,
          total_pages,
          params: params
        )

        @last_responses.unshift([@first_response])
        @last_responses.flatten!
      end

      def total_pages
        @total_pages ||= first_page.total_pages
      end

      def first_page
        @first_page ||= first_single_page.get(
          path,
          params: params
        )
        @first_response = @first_page.last_response

        @first_page
      end

      def first_single_page
        @first_single_page ||= SinglePage.new
      end

      def client
        @client ||= Connection.new
      end

      def default_params
        {
          per_page: FreckleIO.configuration.per_page
        }
      end
    end
  end
end
