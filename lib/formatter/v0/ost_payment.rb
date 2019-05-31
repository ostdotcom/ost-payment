module Formatter
  module V0
    class OstPayment
      class << self

        # Format
        # Always receives [Hash]
        # :NOTE return as is
        #
        # * Author: Aman
        # * Date:
        # * Reviewed By:
        #
        def generate_token(data_to_format)
          {
              ost_payment_token: data_to_format[:token]
          }
        end

      end
    end
  end
end

