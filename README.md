# freckle-io

[![Build Status](https://travis-ci.com/sirion1987/freckle-io.svg?branch=master)](https://travis-ci.com/sirion1987/freckle-io)
[![Maintainability](https://api.codeclimate.com/v1/badges/051732f42b5e59d60a5a/maintainability)](https://codeclimate.com/github/sirion1987/Freckle-io/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/051732f42b5e59d60a5a/test_coverage)](https://codeclimate.com/github/sirion1987/Freckle-io/test_coverage)

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
  c.per_page = 20
  c.max_concurrency = 5
end
```

You can set:

1. `FRECKLE_URL`: the URL of the Freckle API. The default value
   is `https://api.letsfreckle.com/v2`.
2. `auth_type`: the authentication type which will use with the server.
   Currently, the only allowed values is:
   * `:freckle_token`: uses your Freckle API token.
3. `per_page`: the number of items included for each page. The default
   value is 30.
4. `max_concurrency`: max thread for each requests.

## Example

```ruby
require 'dotenv'
require 'freckle-io'

FreckleIO.configure do |c|
  c.token = ENV["FRECKLE_TOKEN"]
  c.auth_type = :freckle_token
  c.max_concurrency = 5
end

client_users = FreckleIO::Client::Users.new.all

client_users.last_responses.each do |resp|
  resp.body
end
```

# Testing

The test suite uses the [VCR](https://github.com/vcr/vcr) gem.

The contents of the cassettes is anonymized (see spec/spec_helper.rb).

## Regenerating the VCR cassettes

Occasionally, it is a good idea to regenerate the cassettes in order to
do an end-to-end test.

Make sure you have correctly set the `.env.test` file. Inside this file
you must specify the keys:

* `FRECKLE_TOKEN`: your Freckle API token;
* `FRECKLE_URL`: Freckle API url;
* `REAL_FRECKLE_USER_ID`: a real user id.

```shell
$ rm -rf spec/fixtures/vcr_cassettes/*
$ bundle
$ bundle exec rspec
```

# Compatibility

This client is set for work with the version 2 (v2) of the Freckle API.

# Supported Ruby Versions

This library is tested against the following Ruby implementations:

* Ruby 2.4
* Ruby 2.5
