module Webapps
  module Gateway
    module GenerateGatewayToken
      class Braintree < Base


        # init  Webapps::Gateway::GenerateGatewayToken
        #
        # * Author: Mayur
        # * Date: 31/05/2019
        # * Reviewed By
        #
        def initialize(params)
          super(params)
          @braintree_gateway = ::Gateway::Braintree.new(@params)

        end

        # perform i.e calls generate_token of braintree gateway
        #
        # * Author: Mayur
        # * Date: 31/05/2019
        # * Reviewed By
        #
        def perform

          r = validate
          return r unless r.success?

          res = @braintree_gateway.generate_token({customer_id: @params[:customer_id]})
        end

      end

    end
  end
end