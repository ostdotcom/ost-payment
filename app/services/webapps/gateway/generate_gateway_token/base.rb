module Webapps
  module Gateway
    module GenerateGatewayToken

      class Base < ServicesBase

        def initialize(params)
          super(params)
        end

        def perform
          raise "Child needs to implement this"
        end

      end

    end
  end
end