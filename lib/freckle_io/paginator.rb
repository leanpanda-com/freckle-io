require 'uri'
require 'cgi'

module FreckleIO
  class Paginator
    attr_reader :raw_links

    def initialize(raw_links)
      @raw_links = raw_links
    end

    def next
      find("next")&.dig(:url)
    end

    def prev
      find("prev")&.dig(:url)
    end

    def first
      find("first")&.dig(:url)
    end

    def last
      find("last")&.dig(:url)
    end

    def total_pages
      find("last")&.dig(:number_page)
    end

    private

    def find(rel)
      pages.find { |page| page[:rel] == rel }
    end

    def pages
      @pages ||= begin
        raw_links.split(',').map do |link|
          url, rel = link.split(";").map(&:strip)
          rel = rel.gsub(/(rel=)?"/, '')
          url = URI.parse(url[1..-2])
          number_page = CGI.parse(url.query)["page"]

          {
            url: "#{url.path}?#{url.query}",
            rel: rel,
            number_page: number_page.first
          }
        end
      end
    end
  end
end
