require "freckle_io/paginator"

module FreckleIO
  module Request
    class SinglePage
      attr_reader :last_response
      attr_reader :raw_links

      def initialize
        @last_response = nil
        @raw_links = nil
      end

      def get(path, params: {}, request_options: {})
        @last_response = client.get(
          path,
          params: params,
          request_options: request_options
        )

        @raw_links = @last_response.headers["link"] || []

        self
      end

      def next
        next? ? get(paginator.next) : nil
      end

      def next?
        paginator.next
      end

      def prev
        prev? ? get(paginator.prev) : nil
      end

      def prev?
        paginator.prev
      end

      def last
        last? ? get(paginator.last) : nil
      end

      def last?
        paginator.last
      end

      def first
        first? ? get(paginator.first) : nil
      end

      def first?
        paginator.first
      end

      def total_pages
        paginator.total_pages.to_i
      end

      private

      def paginator
        @paginator = Paginator.new(raw_links)
      end

      def client
        @client = Connection.new
      end
    end
  end
end
