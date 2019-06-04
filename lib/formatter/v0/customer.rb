module Formatter
  module V0
    class Customer
      class << self

        # Format
        # Always receives [Hash]
        # :NOTE return as is
        #
        # * Author: Aman
        # * Date:
        # * Reviewed By:
        #
        def create_customer(data_to_format)
          formatted_data = {
              result_type: 'customer',
              customer: customer_base(data_to_format[:customer])
          }

          formatted_data
        end

        # Format
        # Always receives [Hash]
        # :NOTE return as is
        #
        # * Author: Aman
        # * Date:
        # * Reviewed By:
        #
        def update_customer(data_to_format)
          formatted_data = {
              result_type: 'customer',
              customer: customer_base(data_to_format[:customer])
          }

          formatted_data
        end

        private

        # Format customer
        # :NOTE Should receive User object
        #
        # * Author: Aman
        # * Date:
        # * Reviewed By:
        #
        # @returns [Hash]
        #
        def customer_base(customer)
          {
              id: customer[:id],
              status: customer[:status],
              first_name: customer[:details][:first_name],
              last_name: customer[:details][:last_name],
              company: customer[:details][:company],
              email: customer[:details][:email],
              phone: customer[:details][:phone],
              fax: customer[:details][:fax],
              website: customer[:details][:website]
          }
        end

      end
    end
  end
end

