require "dry-validation"

require "freckle-io/configuration"
require "freckle-io/connection"
require "freckle-io/params"
require "freckle-io/errors/configuration"
require "freckle-io/errors/connection"
require "freckle-io/errors/params"
require "freckle-io/request/multiple_pages"
require "freckle-io/request/single_page"
require "freckle-io/validator/restricted_hash"
require "freckle-io/validator/user"
require "freckle-io/validator/project"
require "freckle-io/client/users"
require "freckle-io/client/projects"

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
