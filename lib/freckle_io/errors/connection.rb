module FreckleIO
  module Errors
    module Connection
      class Failed < StandardError; end
      class ResourceNotFound < StandardError; end
      class ClientError < StandardError; end
    end
  end
end
