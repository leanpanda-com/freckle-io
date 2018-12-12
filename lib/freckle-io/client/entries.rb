module FreckleIO
  module Client
    class Entries
      ENTRY_ENDPOINT = "/v2/entries".freeze
      ALLOWED_KEYS = %i(
        user_ids
        description
        project_ids
        tag_ids
        tag_filter_type
        invoice_ids
        import_ids
        from
        to
        invoiced
        invoiced_at_from
        invoiced_at_to
        updated_from
        updated_to
        billable
        approved_at_from
        approved_at_to
        approved_by_ids
        per_page
      ).freeze
      VALIDATOR_MODULE = "FreckleIO::Validator::Entry".freeze

      def all(params = {})
        multiple_pages.get(ENTRY_ENDPOINT, params: entry_params(params))
      end

      # not implemented
      #
      # def show(id)
      #   single_page.get("#{ENTRY_ENDPOINT}/#{id}")
      # end

      private

      def multiple_pages
        @multiple_pages ||= Request::MultiplePages.new
      end

      def entry_params(params)
        @entry_params = Params.new(
          params,
          ALLOWED_KEYS,
          VALIDATOR_MODULE
        ).call
      end
    end
  end
end
