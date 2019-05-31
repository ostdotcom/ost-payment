module Webapps
  module Gateway
    module GenerateGatewayToken

      class Base < ServicesBase

        def initialize(params)
          super(params)
          @braintree_gateway = Billing::Gateways::BraintreeGateway.new(@params)

        end

        def perform

        end

      end

    end
  end
end