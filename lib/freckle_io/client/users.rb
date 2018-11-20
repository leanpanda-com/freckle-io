module FreckleIO
  module Client
    class Users
      USER_ENDPOINT = "/v2/users".freeze
      ALLOWED_KEYS = %i(name).freeze
      VALIDATOR = FreckleIO::Validator::User

      def all(params = {})
        multiple_pages.get(USER_ENDPOINT, params: user_params(params))
      end

      def show(id)
        single_page.get("#{USER_ENDPOINT}/#{id}")
      end

      private

      def multiple_pages
        @multiple_pages ||= Request::MultiplePages.new
      end

      def single_page
        @single_page ||= Request::SinglePage.new
      end

      def user_params(params)
        @user_params = Params.new(
          params,
          ALLOWED_KEYS,
          VALIDATOR
        ).call
      end
    end
  end
end
