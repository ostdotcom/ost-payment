module Webapps
  module Gateway
    module Factory
      class Base < ServicesBase

        # Initialize
        #
        # * Author: Mayur
        # * Date: 30/05/2019
        # * Reviewed By:
        #
        # @param [AR] ost_payment_token (mandatory) - ost payment token obj
        # @param [Integer] gateway_type (optional) - gateway type to use
        #
        # @return [Webapps::Gateway::Factory::Base]
        #
        def initialize(params)
          super(params)

          @gateway_type = params[:gateway_type]
          @ost_payment_token = params[:ost_payment_token]
          @gateway_type = params[:gateway_type]
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
          r = validate_and_sanitize
          return r unless r.success?

          r = merge_client_gateway_information
          return r unless r.success?

          gateway_class.new(params).perform
        end

        private

        # Validate and sanitize
        #
        # * Author: Mayur
        # * Date: 30/05/2019
        # * Reviewed By:
        #
        # @return [Result::Base]
        #
        #
        def validate_and_sanitize
          r = validate
          return r unless r.success?

          r = validate_gateway_type
          return r unless r.success?

          success
        end

        # validate gateway type
        #
        # * Author: Mayur
        # * Date: 31/05/2019
        # * Reviewed By
        #
        def validate_gateway_type
          return error_with_identifier('invalid_api_params',
                                       'w_f_g_b_vgt_1',
                                       ['invalid_gateway_type']
          ) unless GlobalConstant::GatewayType.is_valid_gateway_type?(@gateway_type)

          success
        end

        # Merge GatewayDetail
        #
        # * Author: Mayur
        # * Date: 31/05/2019
        # * Reviewed By
        #
        def merge_client_gateway_information
          gateway_detail = GatewayDetail.get_from_memcache(@ost_payment_token.client_id, @gateway_type)

          return error_with_identifier('invalid_api_params',
                                       'w_f_g_b_mcgi_1',
                                       ['invalid_gateway_type']
          ) unless @params.merge(gateway_detail: gateway_detail)

          success
        end

        # Method to init gatewayclass based on gateway_type
        #
        # * Author: Mayur
        # * Date: 31/05/2019
        # * Reviewed By:
        #
        def gateway_class
          @gateway_class ||= "Webapps::Gateway::#{self.class.name.split('::').last}::#{@gateway_type.titleize}".constantize
        end

      end
    end
  end
end
