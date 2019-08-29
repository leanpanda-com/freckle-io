RSpec.shared_context "with raw links" do
  let(:first_page) do
    # rubocop:disable Metrics/LineLength
    "<https://api.nokotime.com/v2/users?page=2>; rel=\"last\", <https://api.nokotime.com/v2/users?page=2>; rel=\"next\""
    # rubocop:enable Metrics/LineLength
  end

  let(:last_page) do
    # rubocop:disable Metrics/LineLength
    "<https://api.nokotime.com/v2/users?page=1>; rel=\"first\", <https://api.nokotime.com/v2/users?page=1>; rel=\"prev\""
    # rubocop:enable Metrics/LineLength
  end
end
