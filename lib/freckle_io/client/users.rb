module FreckleIO
  module Client
    class Users
      def users
        client.all("/v2/users")
      end

      private

      def client
        @client = FreckleIO::Client.new
      end
    end
  end
end
