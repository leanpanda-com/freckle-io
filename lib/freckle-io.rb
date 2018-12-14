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
require "freckle-io/validator/entry"
require "freckle-io/validator/tag"
require "freckle-io/validator/project_group"
require "freckle-io/client/users"
require "freckle-io/client/projects"
require "freckle-io/client/entries"
require "freckle-io/client/tags"
require "freckle-io/client/project_groups"

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
