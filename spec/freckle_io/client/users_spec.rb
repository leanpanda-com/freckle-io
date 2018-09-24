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
      let(:result) { users.all }

      it "get all users" do
        expect(result.body).to be_a(Array)
      end
    end

    describe "#show" do
      let(:result) { users.show(ENV['REAL_FRECKLE_USER_ID']) }

      it "get a spacific user" do
        expect(result.body.keys).to eq(USER_KEYS)
      end
    end
  end
end
