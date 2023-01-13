module FreckleIO
  module Authentication
    AUTHENTICATION_TYPE = [
      :freckle_token
    ].freeze

    def valid_auth?(type)
      AUTHENTICATION_TYPE.include? type
    end

    def authorize_request(request)
      auth_type = FreckleIO.configuration.auth_type

      case auth_type
      when :freckle_token
        request.headers["X-NokoToken"] = token
      end
    end

    private

    def token
      FreckleIO.configuration.token
    end
  end
end
