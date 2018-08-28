# freckle-io
Yet another Ruby client for the Freekle API

# Usage

1. Configure client with:

   ```
   f = FreckleIO.configure do |c|
     c.token=ENV['FRECKLE_TOKEN']
     c.url = ENV['FRECKLE_URL']
     c.auth_type = :basic_auth
   end
   ```
