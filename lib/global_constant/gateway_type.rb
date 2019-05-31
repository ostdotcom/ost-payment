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

      def is_valid_gateway_type?(gateway_type)
        GlobalConstant::GatewayType.gateway_types_enum.keys.include?(gateway_type) && Util::CommonValidateAndSanitize.is_string?(gateway_type)
      end

    end

  end

end
