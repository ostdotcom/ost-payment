module Webapps
  module Gateway
    module Factory
      class Base < ServicesBase

        def initialize(params)
          super(params)
        end


        # Perform : i.e. calls perform of expected class
        #
        # * Author: Mayur
        # * Date: 31/05/2019
        # * Reviewed By:
        def perform

          r = validate

          return r unless r.success?

          r = validate_gateway_type

          return r unless r.success?

          initialize_gateway_class

          details = get_client_gateway_information

          params = @params.merge(gateway_details: details)

          gateway_instance = @gateway_class.new(params)

          gateway_instance.perform

        end


        # Method to init gatewayclass based on gateway_type
        #
        # * Author: Mayur
        # * Date: 31/05/2019
        # * Reviewed By:
        #
        def initialize_gateway_class

          gateway_type = @params[:gateway_type].titleize

          @gateway_class = "Webapps::Gateway::#{self.class.name.split('::').last}::#{gateway_type}".constantize

        end



        # validate gateway type
        #
        # * Author: Mayur
        # * Date: 31/05/2019
        # * Reviewed By
        #
        def validate_gateway_type

          is_valid = GlobalConstant::GatewayType.is_valid_gateway_type?(@params[:gateway_type])

          return error_with_data(
          'mpm_1',
              'invalid gateway type',
              'invalid_gateway_type',
              GlobalConstant::ErrorAction.default,
              {}
          ) unless is_valid
          success

        end


        # Perform : i.e. get client gateway information
        #
        # * Author: Mayur
        # * Date: 31/05/2019
        # * Reviewed By
        #
        def get_client_gateway_information
          ost_payment_tokens_object = @params[:ost_payment_tokens_object]
          gateway_details = GatewayDetail.get_from_memcache(ost_payment_tokens_object.client_id,
                                                            @params[:gateway_type])
          gateway_details.details
        end





      end
    end
  end
end
