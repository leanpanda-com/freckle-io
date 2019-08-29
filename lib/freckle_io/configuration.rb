require "freckle_io/authentication"

module FreckleIO
  class Configuration
    include Authentication

    DEFAULT_URL = "https://api.nokotime.com/v2".freeze

    attr_writer :auth_type
    attr_writer :token
    attr_writer :url
    attr_writer :per_page
    attr_writer :max_concurrency

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

    def per_page
      @per_page || nil
    end

    def max_concurrency
      @max_concurrency || raise(
        Errors::Configuration, "Max concurrency missing!"
      )
    end
  end
end
