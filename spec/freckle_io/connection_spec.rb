require_relative "../spec_helper"

describe FreckleIO::Connection do
  context "with configuration", :vcr do
    before do
      FreckleIO.reset
      FreckleIO.configure do |config|
        config.token = ENV["FRECKLE_TOKEN"]
        config.auth_type = :freckle_token
      end
    end

    let(:connection) { described_class.new }
    let(:users) { connection.get("/v2/users") }

    describe "with header" do
      it "set user agent" do
        ua = users.env.request_headers["User-Agent"]

        expect(ua).to eq "MyFreckleBot/1.0"
      end
    end

    describe "with freckle token authentication" do
      it "set X-FreckleToken" do
        header_token = users.env.request_headers["X-FreckleToken"]

        expect(header_token).not_to be nil
      end
    end

    describe "with invalid host" do
      before do
        FreckleIO.reset
        FreckleIO.configure do |config|
          config.token = ENV["FRECKLE_TOKEN"]
          config.url = "http://not.existing.domain"
          config.auth_type = :freckle_token
        end
      end

      let(:invalid_request) { connection.get("/") }

      it "raises a connection error for invalid host" do
        expect do
          invalid_request
        end.to raise_error(FreckleIO::Errors::Connection::Failed)
      end
    end

    describe "with too many request" do
      # per_page = 1 raise Faraday::ClientError: the server responded
      # with status 429 (Too Many Requests)
      #
      # HTTP/1.1 429 Too Many Requests
      # Content-Type: text/html
      # Retry-After: 3600
      # https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/429
    end

    describe "#get" do
      context "with params" do
        let(:users) { connection.get("/v2/users", params: {page: 2}) }

        it "returns an array of users" do
          expect(users.body).to be_a Array
        end

        it "returns an user" do
          expect(users.body.first.keys).to eq(USER_KEYS)
        end
      end

      context "without params" do
        it "returns an array of users" do
          expect(users.body).to be_a Array
        end

        it "returns an user" do
          expect(users.body.first.keys).to eq(USER_KEYS)
        end
      end

      context "with invalid url" do
        let(:invalid_resource) { connection.get("/invalid_url") }

        it "raises a resource not found error for invalid resource" do
          expect do
            invalid_resource
          end.to raise_error(FreckleIO::Errors::Connection::ResourceNotFound)
        end

        it "raises a conncection failed error" do
        end
      end

      context "with connection timeout" do
        # https://github.com/lostisland/faraday/issues/561

        let(:connection) { described_class.new }
        let(:resource) do
          connection.get("/v2/users", request_options: {timeout: 0})
        end

        it "raises a timeout error" do
          expect do
            resource
          end.to raise_error(FreckleIO::Errors::Connection::Failed)
        end
      end

      context "with connection open timeout" do
        let(:connection) { described_class.new }
        let(:resource) do
          connection.get(
            "/v2/users",
            request_options: {
              timeout: 0,
              open_timeout: 0
            }
          )
        end

        it "raises a timeout error" do
          expect do
            resource
          end.to raise_error(FreckleIO::Errors::Connection::Failed)
        end
      end
    end
  end
end
