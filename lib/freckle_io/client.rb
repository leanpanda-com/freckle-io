require 'freckle_io/authentication'
require 'freckle_io/paginator'
require 'freckle_io/client/users'
require 'faraday'
require 'faraday_middleware'

module FreckleIO
  class Client
    include FreckleIO::Authentication
    include FreckleIO::Client::Users

    attr_reader :body
    attr_reader :raw_links

    def get(path)
      response = connection.get(path) do |request|
        authorize_request(request)
      end

      @raw_links = response.headers["link"] || []
      @body = response.body

      response
    end

    def next
      next_page = paginator.next
      next_page ? get(next_page) : nil
    end

    def prev
      prev_page = paginator.prev
      prev_page ? get(prev_page) : nil
    end

    def last
      last_page = paginator.last
      last_page ? get(last_page) : nil
    end

    def first
      first_page = paginator.first
      first_page ? get(first_page) : nil
    end

    def paginate
    end

    private

    def paginator
      @paginator = FreckleIO::Paginator.new(raw_links)
    end

    def connection
      options = {
        url: FreckleIO.configuration.url,
        headers: {
          user_agent: 'MyFreckleBot/1.0',
        }
      }

      @connection ||= Faraday.new(options) do |connection|
        connection.request  :json
        connection.response :json, content_type: /\bjson$/
        connection.adapter  Faraday.default_adapter
      end
    end
  end
end
