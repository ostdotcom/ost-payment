module Webapps
  module Gateway
    module GenerateGatewayToken

      class Base < ServicesBase

        def initialize(params)
          puts "Paramssss #{params}"
          super(params)
          @braintree_gateway = Gateway::Braintree.new(@params)

        end

        def perform

        end

      end

    end
  end
end