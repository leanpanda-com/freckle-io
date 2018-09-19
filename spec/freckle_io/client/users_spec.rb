require_relative "../../spec_helper"
require "pry"

describe FreckleIO::Client::Users do
  context "with configuration", :vcr do
    before do
      FreckleIO.reset
      FreckleIO.configure do |config|
        config.token = ENV["FRECKLE_TOKEN"]
        config.auth_type = :freckle_token
      end
    end

    let(:client) { FreckleIO::Client.new }

    describe "#users" do
      before do
        client.users
      end

      it "get all users" do
        expect(client.next).to eq nil
      end
    end
  end
end
