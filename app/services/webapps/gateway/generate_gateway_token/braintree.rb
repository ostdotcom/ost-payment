module Webapps
  module Gateway
    module GenerateGatewayToken
      class Braintree < Base

        def initialize(params)

          super(params)

        end

        def perform
          @braintree_gateway.client_token.generate({customer_id: @params[:customer_id]})
        end

      end

    end
  end
end