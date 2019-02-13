require_relative "../../spec_helper"

describe FreckleIO::Client::ProjectGroups do
  context "with configuration", :vcr do
    describe "#all" do
      let(:results) { subject.all }
      let(:first_response) { results.last_responses.first }

      it "result must be a Request::MultiplePages" do
        expect(results).to be_a(FreckleIO::Request::MultiplePages)
      end

      it "returns a project group for each response" do
        results.last_responses.each do |last_response|
          expect(last_response.body.first.keys).to eq PROJECT_GROUP_KEYS
        end
      end
    end

    # describe "#show" do
    #   let(:result) { subject.show(ENV["REAL_FRECKLE_PROJECT_GROUP_ID"]) }
    #   let(:response) { result.last_response }

    #   it "get a spacific project group" do
    #     expect(response.body.keys).to eq(PROJECT_GROUP_KEYS)
    #   end

    #   it "raw links should be a empty array" do
    #     expect(result.raw_links).to be_empty
    #   end
    # end

    describe "with valid params" do
      let(:params) do
        {
          name: "valid_string",
          project_ids: "1,2,3",
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

    describe "with project ids" do
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
      let(:project_group_validator) do
        class_double(
          FreckleIO::Validator::ProjectGroup,
          errors: {},
          output: {}
        )
      end

      let(:result) do
        subject.all
      end

      before do
        allow(FreckleIO::Validator::ProjectGroup).to receive(
          :validation
        ).with({}, FreckleIO::Client::ProjectGroups::ALLOWED_KEYS) do
          project_group_validator
        end

        allow(FreckleIO::Validator::ProjectGroup).to receive(:errors)
        allow(FreckleIO::Validator::ProjectGroup).to receive(:output)

        result
      end

      it "call project group's validator" do
        expect(FreckleIO::Validator::ProjectGroup).to have_received(
          :validation
        )
      end
    end
  end
end
