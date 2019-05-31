# frozen_string_literal: true
module GlobalConstant

  class GatewayType

    class << self

      def braintree_gateway_type
        'braintree'
      end



      def gateway_types_enum
        {
            braintree_gateway_type => 1
        }
      end

    end

  end

end
