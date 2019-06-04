module Webapps
  module Gateway
    module GenerateGatewayToken

      class Base < ServicesBase

        include Util::GatewayHelper

        # Initialize
        #
        # * Author: Mayur
        # * Date: 30/05/2019
        # * Reviewed By:
        #
        # @param [AR] gateway_detail (mandatory) - gateway detail obj
        # @param [AR] ost_payment_token (mandatory) - ost payment token obj
        # @param [Integer] customer_id (optional) - customer id
        #
        # @return [Webapps::Gateway::GenerateGatewayToken::Base]
        #
        # Sets @customer, @gateway_customer_association
        #
        def initialize(params)
          super(params)
          @gateway_detail = params[:gateway_detail]
          @ost_payment_token = params[:ost_payment_token]
          @customer_id = params[:customer_id]

          @customer = nil
          @gateway_customer_association = nil
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

          r = create_customer_in_gateway
          return r unless r.success?

          r = gateway_client.generate_token({customer_id: gateway_customer_id})
          return r unless r.success?

          success_with_data({gateway_token: r.data[:gateway_token]})
        end

        private

        # Validate and sanitize
        #
        # * Author: Aman
        # * Date: 30/05/2019
        # * Reviewed By:
        #
        # @return [Result::Base]
        #
        # Sets customer
        #
        def validate_and_sanitize
          r = validate
          return r unless r.success?

          r = validate_and_set_customer
          return r unless r.success?

          success
        end

        # validate_and_set_customer
        #
        # * Author: Aman
        # * Date: 3/06/2019
        # * Reviewed By:
        #
        # @return [Result::Base]
        #
        # Sets customer
        #
        def validate_and_set_customer
          @customer_id = @customer_id.to_i
          return success if @customer_id <= 0

          @customer = Customer.get_from_memcache(@customer_id)

          return error_with_identifier('invalid_api_params',
                                       'ra_c_u_vci_2',
                                       ['invalid_id']
          ) if @customer.blank? || @customer.status != GlobalConstant::Customer.active_status ||
              @customer.client_id != @ost_payment_token.client_id

          success
        end

        # create customer if not present
        #
        # * Author: Aman
        # * Date: 3/06/2019
        # * Reviewed By:
        #
        # @return [Result::Base]
        #
        # Sets customer
        #
        def create_customer_in_gateway
          return success if @customer.blank?

          gateway_customer_associations = GatewayCustomerAssociation.get_all_from_memcache(@id).index_by(&:gateway_type)
          @gateway_customer_association = gateway_customer_associations[@gateway_detail.gateway_type]

          return success if @gateway_customer_association.present?

          r = "GatewayManagement::Customer::Create::#{@gateway_detail.gateway_type.camelize}".constantize.
              new(customer: @customer, client_id: @ost_payment_token.client_id).perform
          return r unless r.success?

          @gateway_customer_association = r.data[:gateway_customer_association]

          success
        end

        # get gateway customer id if present
        #
        # * Author: Aman
        # * Date: 30/05/2019
        # * Reviewed By:
        #
        # @return [String]
        #
        def gateway_customer_id
          @customer_id > 0 ? @gateway_customer_association.gateway_customer_id : nil
        end

        # gateway client wrapper instance
        #
        # * Author: Aman
        # * Date: 30/05/2019
        # * Reviewed By:
        #
        # @return [String]
        #
        #
        def gateway_client
          @gateway_client ||= get_gateway_client({client_id: @client_id, gateway_type: gateway_type})
        end

      end

    end
  end
end