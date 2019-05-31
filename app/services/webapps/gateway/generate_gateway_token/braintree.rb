module Webapps
  module Gateway
    module GenerateGatewayToken
      class Braintree < Base

        def initialize(params)
          super(params)
        end

        def perform
          res = @braintree_gateway.generate_token({customer_id: @params[:customer_id]})
          puts "#{res.inspect},........ res"
        end

      end

    end
  end
end