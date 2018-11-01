require "uri"
require "cgi"

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
      return {} if raw_links == "" || raw_links.empty?

      @pages ||=
        raw_links.split(",").map do |link|
          url, rel, number_page = split_and_clean_link(link)

          {
            url: "#{url.path}?#{url.query}",
            rel: rel,
            number_page: number_page
          }
        end
    end

    # Example of link response headers:
    # "<https://api.letsfreckle.com/v2/users?page=2>; rel=\"last\""
    #
    # The first element is an URI. "Rel" means the relative position
    # of the current page, in this case is last page.

    def split_and_clean_link(link)
      raw_url, rel = link.split(";").map(&:strip)

      raw_url = raw_url.gsub(/<|>/, "")
      rel = rel.gsub(/(rel=)?"/, "")
      url = URI.parse(raw_url)
      page = CGI.parse(url.query)["page"].first

      [url, rel, page]
    end
  end
end
