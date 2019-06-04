module Webapps
  module Gateway
    module GenerateGatewayToken
      class Braintree < Base

        # Initialize
        #
        # * Author: Mayur
        # * Date: 30/05/2019
        # * Reviewed By:
        #
        # @param [AR] gateway_detail (mandatory) - gateway detail obj
        # @param [AR] ost_payment_token (mandatory) - ost payment token obj
        # @param [Integer] customer_id (optional) - customer id
        #
        # @return [Webapps::Gateway::GenerateGatewayToken::Braintree]
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