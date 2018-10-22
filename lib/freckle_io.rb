require "freckle_io/configuration"
require "freckle_io/errors/configuration"
require "freckle_io/errors/connection"
require "freckle_io/connection"
require "freckle_io/client/users"
require "freckle_io/request/single_page"

module FreckleIO
  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset
    @configuration = Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
