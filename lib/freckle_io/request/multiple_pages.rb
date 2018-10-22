module FreckleIO
  module Request
    class MultiplePages
      attr_reader :last_response

      def initialize
        @last_response = nil
      end

      def all

      end

      private

      def client
        @client = FreckleIO::Connection.new
      end
    end
  end
end
