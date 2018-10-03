require "freckle_io/authentication"

module FreckleIO
  class Configuration
    include FreckleIO::Authentication

    DEFAULT_URL = "https://api.letsfreckle.com/v2".freeze

    attr_writer :auth_type
    attr_writer :token
    attr_writer :url

    def initialize
      @token = nil
    end

    def auth_type
      unless valid_auth?(@auth_type)
        raise(
          Errors::Configuration,
          "#{@auth_type} isn't valid type authentication"
        )
      end

      @auth_type || raise(Errors::Configuration, "Authentication type missing!")
    end

    def token
      @token || raise(Errors::Configuration, "Token missing!")
    end

    def url
      @url || self.class::DEFAULT_URL
    end
  end
end
