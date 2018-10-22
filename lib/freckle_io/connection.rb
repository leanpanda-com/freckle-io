require "freckle_io/authentication"
require "freckle_io/paginator"
require "faraday"
require "faraday_middleware"

module FreckleIO
  class Connection
    include FreckleIO::Authentication

    def get(path, params: {}, request_options: {})
      response = connection.get do |request|
        authorize_request(request)
        set_request_options(request, request_options)
        request.url path, params
      end

      response
    rescue Faraday::ConnectionFailed => e
      raise FreckleIO::Errors::Connection::Failed.new(e), e.message
    rescue Faraday::ResourceNotFound => e
      raise FreckleIO::Errors::Connection::ResourceNotFound.new(e), e.message
    end

    def all(path)
      page = get(path)
      page_body = page.env.body

      loop do
        break if !next?

        next_page = self.next
        next_response_headers = next_page.env.response_headers
        page_body.concat(next_page.body) if next_page.body.is_a? Array
        page.env.response_headers = next_response_headers
      end

      page
    end

    private

    def connection
      @connection ||= Faraday.new(default_options) do |connection|
        connection.request  :json
        connection.response :json, content_type: /\bjson$/
        connection.response :raise_error
        connection.adapter  :net_http
      end
    end

    def default_options
      {
        url: FreckleIO.configuration.url,
        headers: {
          user_agent: "MyFreckleBot/1.0"
        }
      }
    end

    def set_request_options(request, options)
      request.options.timeout = options[:timeout]
      request.options.open_timeout = options[:open_timeout]
    end
  end
end
