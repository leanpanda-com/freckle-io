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

      it "returns a user for each response" do
        results.last_responses.each do |last_response|
          expect(last_response.body.first.keys).to eq USER_KEYS
        end
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

    describe "with valid params" do
      let(:params) do
        {
          name: "valid_string",
          email: "email@domain.com",
          role: "coworker",
          state: "active"
        }
      end

      let(:results) { subject.all(params) }

      it "params should be valid" do
        expect do
          results
        end.not_to raise_error
      end
    end

    describe "with unknow params" do
      let(:params) do
        {
          invalid_params: "oh! oh!"
        }
      end

      let(:results) { subject.all(params) }

      it "raises a invalid params error" do
        expect do
          results
        end.to raise_error(FreckleIO::Errors::Params::InvalidParams)
      end
    end

    describe "with wrong email" do
      let(:params) do
        {
          email: "invalid_email"
        }
      end

      let(:results) { subject.all(params) }

      it "raises a invalid params error" do
        expect do
          results
        end.to raise_error(FreckleIO::Errors::Params::InvalidParams)
      end
    end

    describe "with wrong role" do
      let(:params) do
        {
          role: "invalid_role"
        }
      end

      let(:results) { subject.all(params) }

      it "raises a invalid params error" do
        expect do
          results
        end.to raise_error(FreckleIO::Errors::Params::InvalidParams)
      end
    end

    describe "with state role" do
      let(:params) do
        {
          state: "invalid_state"
        }
      end

      let(:results) { subject.all(params) }

      it "raises a invalid params error" do
        expect do
          results
        end.to raise_error(FreckleIO::Errors::Params::InvalidParams)
      end
    end
  end
end
