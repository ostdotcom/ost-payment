module GatewayManagement::CreateCustomer
  class Base

    include Util::ResultHelper

    def initialize(params)
      @client_id = params[:client_id]
      @customer = params[:customer]

      @gateway_customer_association = nil
    end

    # perform
    #
    # * Author: Aman
    # * Date: 30/05/2019
    # * Reviewed By:
    #
    # @return [Hash]
    #
    def perform
      r = validate_and_sanitize
      return r unless r.success?

      r = create_customer_in_gateway
      return r unless r.success?

      success_with_data({gateway_customer_association: @gateway_customer_association})
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
    #
    def validate_and_sanitize
      return error_with_identifier('forbidden_api_request',
                                   'gm_cc_b_vs_1',
                                   ['inactive_gateway']
      ) if gateway_details.blank?

      success
    end

    # Create a customer
    #
    # * Author: Aman
    # * Date: 30/05/2019
    # * Reviewed By:
    #
    # @return [Result::Base]
    #
    #
    def create_customer_in_gateway
      resp = gateway_client.create_customer(create_params)
      gateway_customer_id = resp.id

      @gateway_customer_association = GatewayCustomerAssociation.create(
          customer_id: @customer.id,
          gateway_type: @gateway_nonce.gateway_type,
          gateway_customer_id: gateway_customer_id
      )

      success
    end


    # gateway type
    #
    # * Author: Aman
    # * Date: 30/05/2019
    # * Reviewed By:
    #
    # @return [String]
    #
    #
    def gateway_type
      fail 'unimplemented method gateway_type'
    end

    # gateway type
    #
    # * Author: Aman
    # * Date: 30/05/2019
    # * Reviewed By:
    #
    # @return [String]
    #
    #
    def gateway_class
      "Gateway::#{gateway_type.camelize}".constantize
    end

    # gateway type
    #
    # * Author: Aman
    # * Date: 30/05/2019
    # * Reviewed By:
    #
    # @return [String]
    #
    #
    def gateway_client
      @gateway_client ||= gateway_class.new(gateway_client_params)
    end

    # gateway type
    #
    # * Author: Aman
    # * Date: 30/05/2019
    # * Reviewed By:
    #
    # @return [Hash]
    #
    def gateway_client_params
      gateway_details.decrypted_details
    end

    # get gateway details obj
    #
    # * Author: Aman
    # * Date: 30/05/2019
    # * Reviewed By:
    #
    # @return [AR] GatewayDetail obj
    #
    def gateway_details
      @gateway_details ||= GatewayDetail.get_from_memcache(@client_id, gateway_type)
    end

    # create_params for api call
    #
    # * Author: Aman
    # * Date: 30/05/2019
    # * Reviewed By:
    #
    # @return [String]
    #
    #
    def create_params
      fail 'unimplemented method create_params'
    end



  end
end