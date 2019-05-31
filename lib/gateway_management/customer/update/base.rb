module GatewayManagement::Customer::Update
  class Base

    include Util::ResultHelper
    include Util::GatewayHelper

    def initialize(params)
      @client_id = params[:client_id]
      @customer = params[:customer]
      @gateway_nonce = params[:gateway_nonce]
      @gateway_customer_association = params[:gateway_customer_association]

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

      r = update_customer_in_gateway
      return r unless r.success?

      success
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
      ) if gateway_client.blank?

      success
    end

    # update a customer
    #
    # * Author: Aman
    # * Date: 30/05/2019
    # * Reviewed By:
    #
    # @return [Result::Base]
    #
    #
    def update_customer_in_gateway
      resp = gateway_client.update_customer(update_params)
      return resp unless resp.success?

      puts(resp.inspect)

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
      @gateway_client ||= get_gateway_client(@client_id, gateway_type)
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


    # update_params for api call
    #
    # * Author: Aman
    # * Date: 30/05/2019
    # * Reviewed By:
    #
    # @return [String]
    #
    #
    def update_params
      fail 'unimplemented method update_params'
    end

  end
end