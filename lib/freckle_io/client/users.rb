module FreckleIO
  class Client
    module Users
      def users
        get "/v2/users"
      end
    end
  end
end
