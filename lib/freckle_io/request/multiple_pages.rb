require "faraday_middleware"

module FreckleIO
  module Request
    class MultiplePages
      attr_reader :last_response

      def initialize
        @first_page = nil
        @total_pages = 0
        @last_responses = []
      end

      def get(path)
        require "pry"; binding.pry
      end

      private

      def first_page(path)
        @first_page ||= first_single_page.get(path)
      end

      def total_pages
        @total_pages ||= @first_page.total_pages
      end

      def x
        (2..total_pages).map do |page|
          ["path page = 1,2,3, ..:."]
        end
      end

      def first_single_page
        @first_single_page ||= FreckleIO::Request::SinglePage.new
      end

      def client
        @client ||= FreckleIO::Connection.new
      end
    end
  end
end
