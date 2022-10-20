require_relative "../spec_helper"

describe FreckleIO::Configuration do
  let(:freckle_token) { ENV.fetch("FRECKLE_TOKEN", nil) }
  let(:freckle_url) { ENV.fetch("FRECKLE_URL", nil) }

  context "with right configuration" do
    before do
      FreckleIO.reset
      FreckleIO.configure do |config|
        config.token = freckle_token
        config.url = freckle_url
      end
    end

    it "return the correct token" do
      expect(
        FreckleIO.configuration.token
      ).to eq freckle_token
    end

    it "return the correct url" do
      expect(
        FreckleIO.configuration.url
      ).to eq freckle_url
    end
  end

  context "with wrong configuration" do
    before do
      FreckleIO.reset
      FreckleIO.configure do |config|
        config.auth_type = :wrong_type
      end
    end

    it "raises a configuration error for authentication type" do
      expect do
        FreckleIO.configuration.auth_type
      end.to raise_error(FreckleIO::Errors::Configuration)
    end
  end

  context "without configuration" do
    before do
      FreckleIO.reset
    end

    it "raises a configuration error for token" do
      expect do
        FreckleIO.configuration.token
      end.to raise_error(FreckleIO::Errors::Configuration)
    end

    it "raises a configuration error for authentication type" do
      expect do
        FreckleIO.configuration.auth_type
      end.to raise_error(FreckleIO::Errors::Configuration)
    end

    it "raises a configuration error for max concurrency" do
      expect do
        FreckleIO.configuration.max_concurrency
      end.to raise_error(FreckleIO::Errors::Configuration)
    end

    it "return default url" do
      expect(
        FreckleIO.configuration.url
      ).to eq FreckleIO::Configuration::DEFAULT_URL
    end
  end
end
