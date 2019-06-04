module Webapps
  module Gateway
    module Factory
      class GenerateGatewayToken < Base

        # Initialize
        #
        # * Author: Mayur
        # * Date: 30/05/2019
        # * Reviewed By:
        #
        # @param [AR] ost_payment_token (mandatory) - ost payment token obj
        # @param [Integer] gateway_type (optional) - gateway type to use
        #
        # @return [Webapps::Gateway::Factory::GenerateGatewayToken]
        #
        def initialize(params)
          super(params)
        end

        # Perform
        #
        # * Author: Mayur
        # * Date: 30/05/2019
        # * Reviewed By:
        #
        # @return [Result::Base]
        #
        def perform
          super
        end

      end

    end
  end
end

