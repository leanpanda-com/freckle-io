require "freckle_io/authentication"
require "freckle_io/paginator"
require "freckle_io/client/users"
require "faraday"
require "faraday_middleware"

module FreckleIO
  class Client
    include FreckleIO::Authentication
    include FreckleIO::Client::Users

    attr_reader :body
    attr_reader :raw_links

    def get(path, params: {})
      response = connection.get do |request|
        authorize_request(request)
        request.url path, params
      end

      @raw_links = response.headers["link"] || []
      @body = response.body

      response
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

    def total_pages
      paginator.total_pages.to_i
    end

    private

    def paginator
      @paginator = FreckleIO::Paginator.new(raw_links)
    end

    def connection
      options = {
        url: FreckleIO.configuration.url,
        headers: {
          user_agent: "MyFreckleBot/1.0"
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
