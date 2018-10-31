# freckle-io

Yet another Ruby client for the Freckle API

# Usage

1. Configure `.env` file. You must define the `FRECKLE_TOKEN` environment
variable with your Freckle API token.

E.g.

```
FRECKLE_TOKEN=123921387213987132987
```

2. Configure client with:

```ruby
FreckleIO.configure do |c|
  c.token = ENV["FRECKLE_TOKEN"]
  c.url = ENV["FRECKLE_URL"]
  c.auth_type = :freckle_token
end
```

You can set:

1. `FRECKLE_URL`: the URL of the Freckle API. The default value
   is `https://api.letsfreckle.com/v2`.
2. `auth_type`: the authentication type which will use with the server.
   Currently, the only allowed values is:
   * `:freckle_token`: uses your Freckle API token.

# Testing

Make sure you have correctly set the `.env.test` file. Inside this file
you must specify the keys:

* `FRECKLE_TOKEN`: your Freckle API token;
* `FRECKLE_URL`: Freckle API url;
* `REAL_FRECKLE_USER_ID`: a real user id.

The test suite uses the [VCR](https://github.com/vcr/vcr) gem.
To regenerate the VCR cassettes, do as follows:

```shell
$ rm -rf spec/fixtures/vcr_cassettes/*
$ bundle
$ bundle exec rspec
```

# Compatibility

This client is set for work with the version 2 (v2) of the Freckle API.
