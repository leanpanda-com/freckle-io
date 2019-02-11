require_relative "../../spec_helper"

describe FreckleIO::Client::Entries do
  context "with configuration", :vcr do
    let(:params) do
      {
        updated_from: "2018-01-15T00:00:00Z",
        updated_to: "2018-01-16T00:00:00Z"
      }
    end

    describe "#all" do
      let(:results) { subject.all(params) }
      let(:first_response) { results.last_responses.first }

      it "result must be a Request::MultiplePages" do
        expect(results).to be_a(FreckleIO::Request::MultiplePages)
      end

      it "returns a entry for each response" do
        results.last_responses.each do |last_response|
          expect(last_response.body.first.keys).to eq ENTRY_KEYS
        end
      end
    end

    # not implemented ?
    #
    # describe "#show" do
    #   let(:result) { subject.show(ENV["REAL_FRECKLE_ENTRY_ID"]) }
    #   let(:response) { result.last_response }

    #   it "get a spacific entry" do
    #     expect(response.body.keys).to eq(ENTRY_KEYS)
    #   end

    #   it "raw links should be a empty array" do
    #     expect(result.raw_links).to be_empty
    #   end
    # end

    describe "with valid params" do
      let(:params) do
        {
          user_ids: "1,2",
          description: "aaa",
          project_ids: "1,2",
          tag_ids: "1,2",
          tag_filter_type: "and",
          from: "2018-01-01",
          to: "2018-01-01",
          updated_from: "2018-01-15T00:00:00Z",
          updated_to: "2018-01-15T00:00:00Z",
          billable: true,
          approved_at_from: "2018-01-15T00:00:00Z",
          approved_at_to: "2018-01-15T00:00:00Z",
          approved_by_ids: "1,2",
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
          invalid_params: "oh! oh!",
          updated_from: "2018-01-15T00:00:00Z",
          updated_to: "2018-01-16T00:00:00Z"
        }
      end

      let(:results) { subject.all(params) }

      it "raises a invalid params error" do
        expect do
          results
        end.to raise_error(FreckleIO::Errors::Params::InvalidParams)
      end
    end

    describe "with wrong user ids" do
      let(:params) do
        {
          user_id: 1234,
          updated_from: "2018-01-15T00:00:00Z",
          updated_to: "2018-01-16T00:00:00Z"
        }
      end

      let(:results) { subject.all(params) }

      it "raises a invalid params error" do
        expect do
          results
        end.to raise_error(FreckleIO::Errors::Params::InvalidParams)
      end
    end

    describe "with wrong description" do
      let(:params) do
        {
          description: 1234,
          updated_from: "2018-01-15T00:00:00Z",
          updated_to: "2018-01-16T00:00:00Z"
        }
      end

      let(:results) { subject.all(params) }

      it "raises a invalid params error" do
        expect do
          results
        end.to raise_error(FreckleIO::Errors::Params::InvalidParams)
      end
    end

    describe "with wrong project ids" do
      let(:params) do
        {
          project_ids: 123,
          updated_from: "2018-01-15T00:00:00Z",
          updated_to: "2018-01-16T00:00:00Z"
        }
      end

      let(:results) { subject.all(params) }

      it "raises a invalid params error" do
        expect do
          results
        end.to raise_error(FreckleIO::Errors::Params::InvalidParams)
      end
    end

    describe "with wrong tag ids" do
      let(:params) do
        {
          tag_ids: 12,
          updated_from: "2018-01-15T00:00:00Z",
          updated_to: "2018-01-16T00:00:00Z"
        }
      end

      let(:results) { subject.all(params) }

      it "raises a invalid params error" do
        expect do
          results
        end.to raise_error(FreckleIO::Errors::Params::InvalidParams)
      end
    end

    describe "with wrong tag filter type" do
      let(:params) do
        {
          tag_filter_type: "or",
          updated_from: "2018-01-15T00:00:00Z",
          updated_to: "2018-01-16T00:00:00Z"
        }
      end

      let(:results) { subject.all(params) }

      it "raises a invalid params error" do
        expect do
          results
        end.to raise_error(FreckleIO::Errors::Params::InvalidParams)
      end
    end

    describe "with wrong from" do
      let(:params) do
        {
          from: 123,
          updated_from: "2018-01-15T00:00:00Z",
          updated_to: "2018-01-16T00:00:00Z"
        }
      end

      let(:results) { subject.all(params) }

      it "raises a invalid params error" do
        expect do
          results
        end.to raise_error(FreckleIO::Errors::Params::InvalidParams)
      end
    end

    describe "with wrong to" do
      let(:params) do
        {
          to: 123,
          updated_from: "2018-01-15T00:00:00Z",
          updated_to: "2018-01-16T00:00:00Z"
        }
      end

      let(:results) { subject.all(params) }

      it "raises a invalid params error" do
        expect do
          results
        end.to raise_error(FreckleIO::Errors::Params::InvalidParams)
      end
    end

    describe "with wrong updated from" do
      let(:params) do
        {
          updated_from: 123
        }
      end

      let(:results) { subject.all(params) }

      it "raises a invalid params error" do
        expect do
          results
        end.to raise_error(FreckleIO::Errors::Params::InvalidParams)
      end
    end

    describe "with wrong updated to" do
      let(:params) do
        {
          updated_to: 123
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
          tag_filter_type: 123,
          updated_from: "2018-01-15T00:00:00Z",
          updated_to: "2018-01-16T00:00:00Z"
        }
      end

      let(:results) { subject.all(params) }

      it "raises a invalid params error" do
        expect do
          results
        end.to raise_error(FreckleIO::Errors::Params::InvalidParams)
      end
    end

    describe "with wrong approved at from" do
      let(:params) do
        {
          approved_at_from: 123,
          updated_from: "2018-01-15T00:00:00Z",
          updated_to: "2018-01-16T00:00:00Z"
        }
      end

      let(:results) { subject.all(params) }

      it "raises a invalid params error" do
        expect do
          results
        end.to raise_error(FreckleIO::Errors::Params::InvalidParams)
      end
    end

    describe "with wrong approved at to" do
      let(:params) do
        {
          approved_at_to: 123,
          updated_from: "2018-01-15T00:00:00Z",
          updated_to: "2018-01-16T00:00:00Z"
        }
      end

      let(:results) { subject.all(params) }

      it "raises a invalid params error" do
        expect do
          results
        end.to raise_error(FreckleIO::Errors::Params::InvalidParams)
      end
    end

    describe "with wrong approved by ids" do
      let(:params) do
        {
          approved_by_ids: 123,
          updated_from: "2018-01-15T00:00:00Z",
          updated_to: "2018-01-16T00:00:00Z"
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
      let(:entry_validator) do
        class_double(
          FreckleIO::Validator::Entry,
          errors: {},
          output: params
        )
      end

      let(:params) do
        {
          updated_from: "2018-01-15T00:00:00Z",
          updated_to: "2018-01-16T00:00:00Z"
        }
      end

      let(:result) do
        subject.all(params)
      end

      before do
        allow(FreckleIO::Validator::Entry).to receive(
          :validation
        ).with(params, FreckleIO::Client::Entries::ALLOWED_KEYS) do
          entry_validator
        end

        allow(FreckleIO::Validator::Entry).to receive(:errors)
        allow(FreckleIO::Validator::Entry).to receive(:output)

        result
      end

      it "call entry's validator" do
        expect(FreckleIO::Validator::Entry).to have_received(
          :validation
        )
      end
    end
  end
end
