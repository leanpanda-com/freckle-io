require "freckle_io/configuration"
require "freckle_io/errors/configuration"
require "freckle_io/connection"
require "freckle_io/client/users"

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
