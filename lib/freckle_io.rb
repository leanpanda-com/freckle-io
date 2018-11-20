require "dry-validation"

require "freckle_io/configuration"
require "freckle_io/connection"
require "freckle_io/params"
require "freckle_io/errors/configuration"
require "freckle_io/errors/connection"
require "freckle_io/errors/params"
require "freckle_io/request/multiple_pages"
require "freckle_io/request/single_page"
require "freckle_io/validator/restricted_hash"
require "freckle_io/validator/user"
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
