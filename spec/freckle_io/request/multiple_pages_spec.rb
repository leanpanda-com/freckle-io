require_relative "../../spec_helper"


describe FreckleIO::Request::MultiplePages do
  context "with configuration", :vcr do
    before do
      FreckleIO.reset
      FreckleIO.configure do |config|
        config.token = ENV["FRECKLE_TOKEN"]
        config.auth_type = :freckle_token
      end
    end

    let(:subject) { described_class.new }
    let(:users) { subject.get("/v2/users") }

    describe "#get" do
      let(:body_response) {}

      xit "returns an array of users" do
      end
    end
  end
end
