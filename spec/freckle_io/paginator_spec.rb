require_relative "../spec_helper"

describe FreckleIO::Paginator do
  let(:result) { described_class.new(raw_links) }

  describe "#next" do
    let(:raw_links) do
      "<https://api.letsfreckle.com/v2/users?page=1>; rel=\"first\",\
         <https://api.letsfreckle.com/v2/users?page=2>; rel=\"next\""
    end

    it "returns link of next page" do
      expect(result.next).to eq("/v2/users?page=2")
    end
  end

  describe "#prev" do
    let(:raw_links) do
      "<https://api.letsfreckle.com/v2/users?page=1>; rel=\"prev\",\
         <https://api.letsfreckle.com/v2/users?page=3>; rel=\"next\""
    end

    it "returns link of previous page" do
      expect(result.prev).to eq("/v2/users?page=1")
    end
  end

  describe "#last" do
    let(:raw_links) do
      "<https://api.letsfreckle.com/v2/users?page=1>; rel=\"prev\",\
         <https://api.letsfreckle.com/v2/users?page=2>; rel=\"last\""
    end

    it "returns link of previous page" do
      expect(result.last).to eq("/v2/users?page=2")
    end
  end

  describe "#first" do
    let(:raw_links) do
      "<https://api.letsfreckle.com/v2/users?page=1>; rel=\"first\",\
         <https://api.letsfreckle.com/v2/users?page=2>; rel=\"next\""
    end

    it "returns link of previous page" do
      expect(result.first).to eq("/v2/users?page=1")
    end
  end

  context "without nil raw links" do
    let(:raw_links) { nil }

    describe "#next" do
      it "return nil" do
        expect(result.next).to eq(nil)
      end
    end

    describe "#prev" do
      it "return nil" do
        expect(result.prev).to eq(nil)
      end
    end

    describe "#last" do
      it "return nil" do
        expect(result.last).to eq(nil)
      end
    end

    describe "#first" do
      it "return nil" do
        expect(result.first).to eq(nil)
      end
    end
  end

  context "without void raw links" do
    let(:raw_links) { "" }

    describe "#next" do
      it "return nil" do
        expect(result.next).to eq(nil)
      end
    end

    describe "#prev" do
      it "return nil" do
        expect(result.prev).to eq(nil)
      end
    end

    describe "#last" do
      it "return nil" do
        expect(result.last).to eq(nil)
      end
    end

    describe "#first" do
      it "return nil" do
        expect(result.first).to eq(nil)
      end
    end
  end
end
