require_relative "../../spec_helper"

describe FreckleIO::Client::Users do
  context "with configuration", :vcr do
    before do
      FreckleIO.reset
      FreckleIO.configure do |config|
        config.token = ENV["FRECKLE_TOKEN"]
        config.auth_type = :freckle_token
      end
    end

    let(:subject) { described_class.new }

    describe "#all" do
      let(:results) { subject.all }
      let(:first_response) { results.last_responses.first }

      it "result must be a Request::MultiplePages" do
        expect(results).to be_a(FreckleIO::Request::MultiplePages)
      end

      it "responses must be a Faraday::Response" do
        expect(results.last_responses).to all(be_a(Faraday::Response))
      end

      it "an element of response must be a valid user" do
        expect(first_response.body.first.keys).to eq(USER_KEYS)
      end
    end

    describe "#show" do
      let(:result) { subject.show(ENV["REAL_FRECKLE_USER_ID"]) }
      let(:response) { result.last_response }

      it "get a spacific user" do
        expect(response.body.keys).to eq(USER_KEYS)
      end

      it "raw links should be a empty array" do
        expect(result.raw_links).to be_empty
      end
    end
  end
end
