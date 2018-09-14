module FreckleIO
  class Client
    module Users
      def users
        all "/v2/users"
      end
    end
  end
end
