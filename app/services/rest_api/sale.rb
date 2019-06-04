module RestApi
  class Sale < ServicesBase

    # Initialize
    #
    # * Author: Aman
    # * Date: 30/05/2019
    # * Reviewed By:
    #
    # @param [AR] client (mandatory) - client obj
    # @param [Integer] customer_id (optional) - customer id
    #
    # Sets customer, ost_payment_token
    #
    # @return [RestApi::Sale]
    #
    def initialize(params)
      super(params)
      @client = @params[:client]

      @payment_nonce_uuid = @params[:payment_nonce_uuid]

      @customer, @gateway_nonce, @payment_method = nil, nil, nil

    end

    # Perform
    #
    # * Author: Aman
    # * Date: 30/05/2019
    # * Reviewed By:
    #
    # @return [Result::Base]
    #
    def perform
      r = validate_and_sanitize
      return r unless r.success?

      sale

      success_with_data({ost_payment_token: @ost_payment_token.get_hash})
    end

    # Sale
    #
    # * Author: Mayur
    # * Date: 30/05/2019
    # * Reviewed By:
    #
    # @return [Result::Base]
    #
    # Sale
    def sale

      get_client_gateway_details

      Gateway::Braintree.sale.new()


    end


    def get_client_gateway_details


    end

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

      r = validate_optional_params
      return r unless r.success?

      r = validate_customer
      return r unless r.success?

      r = validate_payment_nonce_uuid

      success
    end


    # Validate Customer
    #
    # * Author: Aman
    # * Date: 30/05/2019
    # * Reviewed By:
    #
    # @return [Result::Base]
    #
    # Sets customer
    #
    def validate_customer
      return success if @customer_id.blank?

      return error_with_identifier('invalid_api_params',
                                   'ra_s_vc_1',
                                   ['invalid_customer_id']
      ) unless Util::CommonValidateAndSanitize.is_integer?(@customer_id)

      @customer_id = @customer_id.to_i
      @customer = Customer.get_from_memcache(@customer_id)
      return error_with_identifier('invalid_api_params',
                                   'ra_s_vc_2',
                                   ['invalid_customer_id']
      ) if @customer.blank? || (@customer.client_id != @client.id) || (@customer.status != GlobalConstant::Customer.active_status)

      success
    end

    def validate_payment_nonce_uuid

      return success if @payment_nonce_uuid.blank?

      @gateway_nonce = GatewayNonce.get_from_memcache(@payment_nonce_uuid)


      return error_with_identifier('invalid_api_params',
                                   'ra_s_vpnu_1',
                                   ['invalid_payment_nonce_uuid']
      ) if @gateway_nonce.blank? || (@gateway_nonce.status != GlobalConstant::GatewayDetail.active_status)


      success
    end


    def validate_optional_params
      return error_with_identifier('invalid_api_params',
                                   'ra_gt_vop_1',
                                   ['missing_customer_id']
      ) unless @params[:payment_nonce_uuid].present? || (@params[:customer_id] && @params[:payment_method_id])
      success
    end


  end


end