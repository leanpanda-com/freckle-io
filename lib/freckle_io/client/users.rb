module FreckleIO
  module Client
    class Users
      def all
        client.all("/v2/users")
      end

      private

      def client
        @client = FreckleIO::Connection.new
      end
    end
  end
end
