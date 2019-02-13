require_relative "../../spec_helper"

describe FreckleIO::Client::Projects do
  context "with configuration", :vcr do
    describe "#all" do
      let(:results) { subject.all }
      let(:first_response) { results.last_responses.first }

      it "result must be a Request::MultiplePages" do
        expect(results).to be_a(FreckleIO::Request::MultiplePages)
      end

      it "returns a project for each response" do
        results.last_responses.each do |last_response|
          expect(last_response.body.first.keys).to eq PROJECT_KEYS
        end
      end
    end

    describe "#show" do
      let(:result) { subject.show(ENV["REAL_FRECKLE_PROJECT_ID"]) }
      let(:response) { result.last_response }

      it "get a spacific project" do
        expect(response.body.keys).to eq(PROJECT_KEYS)
      end

      it "raw links should be a empty array" do
        expect(result.raw_links).to be_empty
      end
    end

    describe "with valid params" do
      let(:params) do
        {
          name: "valid_string",
          project_group_ids: "1",
          billing_increment: "1",
          enabled: true,
          billable: true,
          per_page: 30
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
          email: 1234
        }
      end

      let(:results) { subject.all(params) }

      it "raises a invalid params error" do
        expect do
          results
        end.to raise_error(FreckleIO::Errors::Params::InvalidParams)
      end
    end

    describe "with wrong project group ids" do
      let(:params) do
        {
          project_group_ids: 1234
        }
      end

      let(:results) { subject.all(params) }

      it "raises a invalid params error" do
        expect do
          results
        end.to raise_error(FreckleIO::Errors::Params::InvalidParams)
      end
    end

    describe "with wrong billing increment" do
      let(:params) do
        {
          billing_increment: "1,3,7"
        }
      end

      let(:results) { subject.all(params) }

      it "raises a invalid params error" do
        expect do
          results
        end.to raise_error(FreckleIO::Errors::Params::InvalidParams)
      end
    end

    describe "with wrong enabled" do
      let(:params) do
        {
          enabled: "oh! oh!"
        }
      end

      let(:results) { subject.all(params) }

      it "raises a invalid params error" do
        expect do
          results
        end.to raise_error(FreckleIO::Errors::Params::InvalidParams)
      end
    end

    describe "with wrong billable" do
      let(:params) do
        {
          billable: "oh! oh!"
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
      let(:project_validator) do
        class_double(
          FreckleIO::Validator::Project,
          errors: {},
          output: {}
        )
      end

      let(:result) do
        subject.all
      end

      before do
        allow(FreckleIO::Validator::Project).to receive(
          :validation
        ).with({}, FreckleIO::Client::Projects::ALLOWED_KEYS) do
          project_validator
        end

        allow(FreckleIO::Validator::Project).to receive(:errors)
        allow(FreckleIO::Validator::Project).to receive(:output)

        result
      end

      it "call project's validator" do
        expect(FreckleIO::Validator::Project).to have_received(
          :validation
        )
      end
    end
  end
end
