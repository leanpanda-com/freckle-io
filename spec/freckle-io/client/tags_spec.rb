require_relative "../../spec_helper"

describe FreckleIO::Client::Tags do
  context "with configuration", :vcr do
    describe "#all" do
      let(:results) { subject.all }
      let(:first_response) { results.last_responses.first }

      it "result must be a Request::MultiplePages" do
        expect(results).to be_a(FreckleIO::Request::MultiplePages)
      end

      it "returns a tag for each response" do
        results.last_responses.each do |last_response|
          expect(last_response.body.first.keys).to eq TAG_KEYS
        end
      end
    end

    # describe "#show" do
    #   let(:result) { subject.show(ENV["REAL_FRECKLE_TAG_ID"]) }
    #   let(:response) { result.last_response }

    #   it "get a spacific tag" do
    #     expect(response.body.keys).to eq(TAG_KEYS)
    #   end

    #   it "raw links should be a empty array" do
    #     expect(result.raw_links).to be_empty
    #   end
    # end

    describe "with valid params" do
      let(:params) do
        {
          name: "valid_string",
          billable: true,
          per_page: 8
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

    describe "with wrong name" do
      let(:params) do
        {
          name: 123
        }
      end

      let(:results) { subject.all(params) }

      it "raises a invalid params error" do
        expect do
          results
        end.to raise_error(FreckleIO::Errors::Params::InvalidParams)
      end
    end

    describe "with billable" do
      let(:params) do
        {
          state: 123
        }
      end

      let(:results) { subject.all(params) }

      it "raises a invalid params error" do
        expect do
          results
        end.to raise_error(FreckleIO::Errors::Params::InvalidParams)
      end
    end

    describe "with validator" do
      let(:tag_validator) do
        class_double(
          FreckleIO::Validator::Tag,
          errors: {},
          output: {}
        )
      end

      let(:result) do
        subject.all
      end

      before do
        allow(FreckleIO::Validator::Tag).to receive(
          :validation
        ).with({}, FreckleIO::Client::Tags::ALLOWED_KEYS) do
          tag_validator
        end

        allow(FreckleIO::Validator::Tag).to receive(:errors)
        allow(FreckleIO::Validator::Tag).to receive(:output)

        result
      end

      it "call tag's validator" do
        expect(FreckleIO::Validator::Tag).to have_received(
          :validation
        )
      end
    end
  end
end
