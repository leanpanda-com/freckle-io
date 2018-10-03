require_relative "../spec_helper"
require "pry"

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
    let!(:users) { connection.get("/v2/users") }

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
    end

    describe "#next" do
      it "returns an array of users" do
        expect(connection.next.body).to be_a Array
      end

      it "returns an user" do
        expect(users.body.first.keys).to eq(USER_KEYS)
      end
    end

    describe "#prev" do
      before do
        connection.next
      end

      it "returns an array of users" do
        expect(connection.prev.body).to be_a Array
      end

      it "returns an user" do
        expect(users.body.first.keys).to eq(USER_KEYS)
      end
    end

    describe "#last" do
      it "returns an array of users" do
        expect(connection.last.body).to be_a Array
      end

      it "returns an user" do
        expect(users.body.first.keys).to eq(USER_KEYS)
      end
    end

    describe "#first" do
      before do
        connection.last
      end

      it "returns an array of users" do
        expect(connection.first.body).to be_a Array
      end

      it "returns an user" do
        expect(users.body.first.keys).to eq(USER_KEYS)
      end
    end

    describe "#total page" do
      context "with first page" do
        it "returns the range of pages" do
          expect(connection.total_pages).to be_a Integer
        end
      end

      context "with other number of page" do
        before do
          connection.next
        end

        it "returns an empty array" do
          expect(connection.total_pages).to eq(0)
        end
      end
    end
  end
end
