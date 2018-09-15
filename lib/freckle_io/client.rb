require 'freckle_io/authentication'
require 'freckle_io/paginator'
require 'freckle_io/client/users'
require 'faraday'
require 'faraday_middleware'
require 'pry'

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

    def all(path)
      page = get(path)

      loop do
        break if !next?

        page.env.body.concat(self.next.body) if page.body.is_a? Array
      end

      page
    end

    def next
      next? ? get(paginator.next) : nil
    end

    def next?
      paginator.next
    end

    def prev
      prev? ? get(paginator.prev) : nil
    end

    def prev?
      paginator.prev
    end

    def last
      last? ? get(paginator.last) : nil
    end

    def last?
      paginator.last
    end

    def first
      first? ? get(paginator.first) : nil
    end

    def first?
      paginator.first
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
