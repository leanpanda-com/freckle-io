require_relative "../spec_helper"

describe FreckleIO::Connection do
  context "with default configuration", :vcr do
    before do
      FreckleIO.reset
      FreckleIO.configure do |config|
        config.token = ENV["FRECKLE_TOKEN"]
        config.auth_type = :freckle_token
      end
    end

    let(:subject) { described_class.new }
    let(:result) { subject.get("/v2/users") }

    describe "with header" do
      let (:ua) { result.env.request_headers["User-Agent"] }

      it "set user agent" do
        expect(ua).to eq "MyFreckleBot/1.0"
      end
    end

    describe "with freckle token authentication" do
      let(:header_token) { result.env.request_headers["X-FreckleToken"] }

      it "set X-FreckleToken" do
        expect(header_token).not_to be nil
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

    describe "with page param" do
      let(:result) { subject.get("/v2/users", params: {page: 2}) }

      it "response must be success" do
        expect(result.success?).to be(true)
      end
    end

    describe "with per_page param" do
      let(:per_page) { 8 }
      let(:result) { subject.get("/v2/users", params: {per_page: per_page}) }

      it "response must have per_page elements" do
        expect(result.body.count).to eq(per_page)
      end
    end

    describe "with invalid url" do
      let(:invalid_resource) { subject.get("/invalid_url") }

      it "raises a resource not found error for invalid resource" do
        expect do
          invalid_resource
        end.to raise_error(FreckleIO::Errors::Connection::ResourceNotFound)
      end
    end
  end

  context "with exceptions" do
    before do
      FreckleIO.reset
      FreckleIO.configure do |config|
        config.token = ENV["FRECKLE_TOKEN"]
        config.auth_type = :freckle_token
      end
    end

    let(:subject) { described_class.new }
    let(:invalid_request) { subject.get("/") }

    describe "with invalid host" do
      before do
        allow(Faraday).to receive(:new).once.and_raise(
          Faraday::ConnectionFailed, "Connection failed"
        )
      end

      it "raises a connection error for invalid host" do
        expect do
          invalid_request
        end.to raise_error(FreckleIO::Errors::Connection::Failed)
      end
    end

    describe "with invalid resource" do
      before do
        allow(Faraday).to receive(:new).once.and_raise(
          Faraday::ResourceNotFound, "Resource not found"
        )
      end

      it "raises a connection error for invalid host" do
        expect do
          invalid_request
        end.to raise_error(FreckleIO::Errors::Connection::ResourceNotFound)
      end
    end
  end
end
