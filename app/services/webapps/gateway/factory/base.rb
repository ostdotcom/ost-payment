module Webapps
  module Gateway
    module Factory
      class Base < ServicesBase

        def initialize(params)
          super(params)
          initialize_gateway_class

        end


        # Method to init gatewayclass based on gateway_type
        #
        # * Author:
        # * Date: 09/10/2017
        # * Reviewed By:
        #
        def initialize_gateway_class

          gateway_type = @params[:gateway_type].titleize

          @gateway_class = "Webapps::Gateway::#{self.class.name.split('::').last}::#{gateway_type}".constantize
          puts "@gateway_class@gateway_class #{@gateway_class}"

        end


        def perform

          r = validate

          return r unless r.success?

          gateway_instance = @gateway_class.new(@params)

          gateway_instance.perform
        end


      end
    end
  end
end
