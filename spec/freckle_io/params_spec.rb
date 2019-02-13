require_relative "../spec_helper"

describe FreckleIO::Params do
  context "when invalid module" do
    subject do
      described_class.new({}, nil, "invalid_module").call
    end

    it "raises a invalid module error" do
      expect do
        subject
      end.to raise_error(FreckleIO::Errors::Params::InvalidModule)
    end
  end
end
