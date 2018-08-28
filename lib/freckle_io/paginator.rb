require 'uri'

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

          {
            url: "#{url.path}?#{url.query}",
            rel: rel
          }
        end
      end
    end
  end
end
