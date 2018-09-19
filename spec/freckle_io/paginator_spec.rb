require_relative "../spec_helper"
require "pry"

describe FreckleIO::Paginator do
  context "with configuration", :vcr do
    before do
      FreckleIO.reset
      FreckleIO.configure do |config|
        config.token = ENV["FRECKLE_TOKEN"]
        config.auth_type = :freckle_token
      end
    end

    let(:client) { FreckleIO::Client.new }
    let!(:request) { client.get("/v2/users") }

    describe "#next" do
      before do
        paginator.next
      end

      let(:paginator) { FreckleIO::Paginator.new(client.raw_links) }

      it "returns link of next page" do
        expect(paginator.next).to eq("/v2/users?page=2")
      end
    end

    describe "#prev" do
      before do
        client.last
        paginator.prev
      end

      let(:paginator) { FreckleIO::Paginator.new(client.raw_links) }

      it "returns link of previous page" do
        expect(paginator.prev).to eq("/v2/users?page=1")
      end
    end

    describe "#last" do
      before do
        paginator.last
      end

      let(:paginator) { FreckleIO::Paginator.new(client.raw_links) }

      it "returns link of previous page" do
        expect(paginator.last).to eq("/v2/users?page=2")
      end
    end

    describe "#first" do
      before do
        client.last
        paginator.first
      end

      let(:paginator) { FreckleIO::Paginator.new(client.raw_links) }

      it "returns link of previous page" do
        expect(paginator.first).to eq("/v2/users?page=1")
      end
    end
  end
end
