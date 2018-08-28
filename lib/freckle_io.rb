require 'freckle_io/configuration'
require 'freckle_io/errors/configuration'
require 'freckle_io/client'

module FreckleIO
  class << self
    attr_accessor :configuration
  end

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
