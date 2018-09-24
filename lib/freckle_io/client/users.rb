module FreckleIO
  module Client
    class Users
      USER_ENDPOINT = "/v2/users".freeze

      def all
        client.all(USER_ENDPOINT)
      end

      def show(id)
        client.get("#{USER_ENDPOINT}/#{id}")
      end

      private

      def client
        @client = FreckleIO::Connection.new
      end
    end
  end
end
