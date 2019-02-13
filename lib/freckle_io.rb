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
require "freckle_io/validator/project"
require "freckle_io/validator/entry"
require "freckle_io/validator/tag"
require "freckle_io/validator/project_group"
require "freckle_io/client/users"
require "freckle_io/client/projects"
require "freckle_io/client/entries"
require "freckle_io/client/tags"
require "freckle_io/client/project_groups"

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
