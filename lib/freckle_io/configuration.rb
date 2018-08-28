require 'freckle_io/authentication'

module FreckleIO
  class Configuration
    include FreckleIO::Authentication

    DEFAULT_URL = 'https://api.letsfreckle.com/v2'.freeze

    attr_writer :token
    attr_writer :url
    attr_writer :auth_type

    def initialize
      @token  = nil
      @url = FreckleIO::Configuration::DEFAULT_URL
    end

    def token
      raise Errors::Configuration, "FreckleIO token missing!" unless @token
      @token
    end

    def url
      @url
    end

    def auth_type
      raise Errors::Configuration, "FreckleIO authentication missing missing!" unless @auth_type
      raise Errors::Configuration, "#{@auth_type} isn't valid type authentication" unless valid_auth?(@auth_type)
      @auth_type
    end
  end
end
