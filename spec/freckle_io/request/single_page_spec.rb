require_relative "../../spec_helper"

describe FreckleIO::Request::SinglePage do
  context "with configuration", :vcr do
    before do
      FreckleIO.reset
      FreckleIO.configure do |config|
        config.token = ENV["FRECKLE_TOKEN"]
        config.auth_type = :freckle_token
      end
    end

    let(:subject) { described_class.new }
    let(:users) { subject.get("/v2/users") }

    describe "#get" do
      let(:body_response) { users.last_response.body }

      it "returns an array of users" do
        expect(body_response).to be_a Array
      end

      it "returns an user" do
        expect(body_response.first.keys).to eq(USER_KEYS)
      end

      it "returns correct raw links for the first page" do
        expect(users.raw_links).to eq first_page
      end
    end

    describe "#next" do
      let(:next_users) { users.next }
      let(:body_response) { next_users.last_response.body }

      it "returns an array of users" do
        expect(body_response).to be_a Array
      end

      it "returns a user" do
        expect(body_response.first.keys).to eq(USER_KEYS)
      end

      it "previous page should be not nil" do
        expect(next_users.prev).to_not be nil
      end

      it "previous page is a SinglePage" do
        expect(next_users.prev).to be_a described_class
      end
    end

    describe "#prev" do
      before do
        users.next
      end

      let(:prev_users) { users.prev }
      let(:body_response) { prev_users.last_response.body }

      it "returns an array of users" do
        expect(body_response).to be_a Array
      end

      it "returns a user" do
        expect(body_response.first.keys).to eq(USER_KEYS)
      end

      it "next page is a SinglePage" do
        expect(prev_users.next).to be_a described_class
      end

      context "when get prev page from the first page" do
        it "prev should be nil" do
          expect(prev_users.prev).to be nil
        end
      end
    end

    describe "#last" do
      before do
        users.last
      end

      let(:last_users) { users }
      let(:body_response) { last_users.last_response.body }

      it "returns an array of users" do
        expect(body_response).to be_a Array
      end

      it "returns a user" do
        expect(body_response.first.keys).to eq(USER_KEYS)
      end

      it "next page should be nil" do
        expect(last_users.next).to be nil
      end

      it "returns correct raw links for the last page" do
        expect(users.raw_links).to eq last_page
      end

      context "when get prev page from the last page" do
        it "prev should be nil" do
          expect(last_users.first.prev).to be nil
        end
      end
    end

    describe "#first" do
      let(:first_users) { users }
      let(:body_response) { first_users.last_response.body }

      it "returns an array of users" do
        expect(body_response).to be_a Array
      end

      it "returns a user" do
        expect(body_response.first.keys).to eq(USER_KEYS)
      end

      it "prev page should be nil" do
        expect(first_users.prev).to be nil
      end

      it "next page should be a SinglePage" do
        expect(first_users.next).to be_a described_class
      end

      context "when get last page from the first page" do
        it "next should be nil" do
          expect(first_users.last.next).to be nil
        end
      end
    end

    describe "#total page" do
      context "with first page" do
        it "returns the range of pages" do
          expect(users.total_pages).to be_a Integer
        end
      end

      context "with next page" do
        before do
          users.next
        end

        it "returns an empty array" do
          expect(users.total_pages).to eq(0)
        end
      end
    end
  end
end
