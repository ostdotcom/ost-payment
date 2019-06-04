module GatewayManagement::Customer::Create
  class Base

    include Util::ResultHelper
    include Util::GatewayHelper

    def initialize(params)
      @client_id = params[:client_id]
      @customer = params[:customer]
      @gateway_nonce = params[:gateway_nonce]

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
                                   ['inactive_gateway_type']
      ) if gateway_client.blank?

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
      return resp unless resp.success?

      puts(resp.inspect)
      gateway_customer_id = resp.data[:result].customer.id

      @gateway_customer_association = GatewayCustomerAssociation.create!(
          customer_id: @customer.id,
          gateway_type: gateway_type,
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
    def gateway_client
      @gateway_client ||= get_gateway_client({client_id: @client_id, gateway_type: gateway_type})
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