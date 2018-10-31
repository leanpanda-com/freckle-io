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
    let(:result) { subject.get("/v2/users") }

    describe "#get" do
      let(:last_responses) { result.last_responses }

      it "returns an array of faraday response" do
        expect(last_responses).to all(be_a(Faraday::Response))
      end

      it "returns an user for each response" do
        last_responses.each do |last_response|
          expect(last_response.body.first.keys).to eq USER_KEYS
        end
      end
    end
  end
end
