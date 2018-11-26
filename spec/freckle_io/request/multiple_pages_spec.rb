require_relative "../../spec_helper"

describe FreckleIO::Request::MultiplePages do
  context "with configuration", :vcr do
    let(:result) { subject.get("/v2/users") }
    let(:default_per_page) { 30 }

    describe "#get" do
      let(:last_responses) { result.last_responses }

      it "returns an array of faraday response" do
        expect(last_responses).to all(be_a(Faraday::Response))
      end

      it "returns freckle default per page elements" do
        expect(last_responses.first.body.count).to eq(default_per_page)
      end
    end
  end

  context "with per page", :vcr do
    before do
      FreckleIO.configure do |config|
        config.per_page = per_page
      end
    end

    let(:per_page) { 19 }
    let(:result) { subject.get("/v2/users") }

    describe "#get" do
      let(:last_responses) { result.last_responses }

      it "return per page number elements" do
        expect(last_responses.first.body.count).to eq(per_page)
      end
    end
  end
end
