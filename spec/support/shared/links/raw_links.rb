RSpec.shared_context "Raw links" do
  let(:first_page) do
    "<https://api.letsfreckle.com/v2/users?page=2>; rel=\"last\", <https://api.letsfreckle.com/v2/users?page=2>; rel=\"next\""
  end

  let(:last_page) do
   "<https://api.letsfreckle.com/v2/users?page=1>; rel=\"first\", <https://api.letsfreckle.com/v2/users?page=1>; rel=\"prev\""
  end
end
