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

    let(:users) { described_class.new }

    describe "#all" do
      before do
        users
      end

      it "get all users" do
        expect(users.all.body).to be_a(Array)
      end
    end
  end
end
