require "freckle-io/authentication"
require "faraday"
require "faraday_middleware"

module FreckleIO
  class Connection
    include FreckleIO::Authentication

    # rubocop:disable Metrics/MethodLength
    def get(path, params: {}, request_options: {})
      response = connection.get do |request|
        authorize_request(request)
        set_request_options(request, request_options)
        request.url path, params
      end

      response
    rescue Faraday::ConnectionFailed => e
      raise Errors::Connection::Failed.new(e), e.message
    rescue Faraday::ResourceNotFound => e
      raise Errors::Connection::ResourceNotFound.new(e), e.message
    rescue Faraday::ClientError => e
      raise Errors::Connection::ClientError.new(e), e.message
    end
    # rubocop:enable Metrics/MethodLength

    def get_in_parallel(
      path,
      from_page_number,
      to_page_number,
      params: {},
      request_options: {}
    )
      responses = []

      connection.in_parallel(manager) do
        (from_page_number..to_page_number).each do |page|
          merged_params = {page: page}.merge(params)

          responses << get(
            path, params: merged_params, request_options: request_options
          )
        end
      end

      responses
    end

    private

    def connection
      @connection ||= Faraday.new(default_options) do |connection|
        connection.request  :json
        connection.response :json, content_type: /\bjson$/
        connection.response :raise_error
        connection.adapter  :typhoeus
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

    def manager
      @manager ||= Typhoeus::Hydra.new(max_concurrency: 5)
    end
  end
end
