# freckle-io
Yet another Ruby client for the Freekle API

# Usage

1. Configure `.env` file. You muste define `FRECKLE_TOKEN` environment
variable with the freckle's token API.

2. Configure client with:

```ruby
FreckleIO.configure do |c|
  c.token=ENV['FRECKLE_TOKEN']
  c.url = ENV['FRECKLE_URL']
  c.auth_type = :freckle_token
end
```

You can set:
1. `FRECKLE_URL`: is the URL of freckle API. The default value is
   `https://api.letsfreckle.com/v2`.
2. `auth_type`: this variable means the authentication type which will
    do with the server. The allowed values are:
   * `:freckle_token `: use freckle's token API.

# How to run the test

Make sure you have correctly set the `.env.test` file. Inside this file
you must specify the keys:

* `FRECKLE_TOKEN`: the freckle's token API;
* `FRECKLE_URL`: the freckle's url;
* `REAL_FRECKLE_USER_ID`: a real user id. This variable will use during
  the test;

The suite test use [VCR](https://github.com/vcr/vcr) gem. For to regenerate
the vcr cassettes you can run: `rm -rf spec/fixtures/vcr_cassettes/*`,
`bundle` and `bundle exec rspec`.

# Example

After configure:

```ruby
users = FreckleIO::Client::Users.new
# show all users
users.all
# show a specific user
users.show(100)
```

# N.B.

This client is set for work with the version 2 (v2) of freckle API.
