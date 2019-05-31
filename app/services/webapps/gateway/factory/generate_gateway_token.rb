module Webapps
  module Gateway
    module Factory
      class GenerateGatewayToken < Base

        def initialize(params)
          super(params)

        end

        def perform
          super
        end




      end

    end
  end
end


# class Webapps::Gateway::Factory::GenerateGatewayToken < Webapps::Gateway::Factory::Base
#
#   def initialize(params)
#     super(params)
#
#     initialize_gateway_class
#
#   end
#
#   def perform
#     super
#   end
#
#
# end
