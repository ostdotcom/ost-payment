module RestApi
  class AddPaymentMethod < ServicesBase

    # Initialize
    #
    # * Author: Tejas
    # * Date: 30/05/2019
    # * Reviewed By:
    #
    # @param [AR] client (mandatory) - client obj
    # @param [String] payment_nonce_uuid (mandatory) - payment nonce uuid
    # @param [Integer] customer_id (optional) - customer id
    #
    # Sets @customer, @ost_payment_token, @gateway_nonce, @add_payment_method_resp
    #
    # @return [RestApi::AddPaymentMethod]
    #
    def initialize(params)
      super(params)
      @client = @params[:client]
      @payment_nonce_uuid = @params[:payment_nonce_uuid]
      @customer_id = @params[:customer_id]

      @customer, @ost_payment_token, @gateway_nonce, @add_payment_method_resp = nil, nil, nil, nil
    end

    # Perform
    #
    # * Author: Tejas
    # * Date: 30/05/2019
    # * Reviewed By:
    #
    # @return [Result::Base]
    #
    def perform
      r = validate_and_sanitize
      return r unless r.success?

      r = add_payment_method
      return r unless r.success?

      r = mark_default_false_to_other_payment_methods
      return r unless r.success?

      r = create_payment_method
      return r unless r.success?

      success_with_data(service_response_data)
    end

    # Validate and sanitize
    #
    # * Author: Tejas
    # * Date: 30/05/2019
    # * Reviewed By:
    #
    # @return [Result::Base]
    #
    def validate_and_sanitize
      r = validate
      return r unless r.success?

      r = validate_payment_nonce_uuid
      return r unless r.success?

      r = validate_customer
      return r unless r.success?

      success
    end

    # Validate Payment Nonce UUID
    #
    # * Author: Tejas
    # * Date: 30/05/2019
    # * Reviewed By:
    #
    # @return [Result::Base]
    #
    # Sets @gateway_nonce
    #
    def validate_payment_nonce_uuid

      @gateway_nonce = GatewayNonce.get_from_memcache(@payment_nonce_uuid)

      return error_with_identifier('invalid_api_params',
                                   'ra_apm_vpnu_1',
                                   ['invalid_payment_nonce_uuid']
      ) if @gateway_nonce.blank? || (@gateway_nonce.status != GlobalConstant::GatewayDetail.active_status)


      success
    end

    # Validate Customer
    #
    # * Author: Tejas
    # * Date: 30/05/2019
    # * Reviewed By:
    #
    # @return [Result::Base]
    #
    # Sets @ost_payment_token, @customer
    #
    def validate_customer

      if @customer_id.blank?
        @ost_payment_token = OstPaymentToken.where(id: @gateway_nonce.ost_payment_token_id).first
        return error_with_identifier('invalid_api_params',
                                     'ra_apm_vc_1',
                                     ['missing_customer_id']
        ) unless @ost_payment_token.customer_id.blank?

        @customer_id = @ost_payment_token.customer_id
      end


      return error_with_identifier('invalid_api_params',
                                   'ra_apm_vc_2',
                                   ['invalid_customer_id']
      ) unless Util::CommonValidateAndSanitize.is_integer?(@customer_id)

      @customer_id = @customer_id.to_i
      @customer = ::Customer.get_from_memcache(@customer_id)
      return error_with_identifier('invalid_api_params',
                                   'ra_apm_vc_3',
                                   ['invalid_customer_id']
      ) if @customer.blank? || (@customer.client_id != @client.id) || (@customer.status != GlobalConstant::Customer.active_status)

      success
    end

    # Add Payment Method
    #
    # * Author: Tejas
    # * Date: 30/05/2019
    # * Reviewed By:
    #
    # @return [Result::Base]
    #
    # Sets @gateway_nonce, @add_payment_method_resp
    #
    def add_payment_method
      @add_payment_method_resp = gateway_client.create_payment_method(add_payment_method_params)

      return @add_payment_method_resp unless @add_payment_method_resp.success?

      puts(@add_payment_method_resp.inspect)

      @gateway_nonce.status = GlobalConstant::GatewayNonce.used_status
      @gateway_nonce.save!

      success
    end

    # gateway type
    #
    # * Author: Aman
    # * Date: 30/05/2019
    # * Reviewed By:
    #
    # @sets @gateway_client
    #
    def gateway_client
      @gateway_client ||= Util::GatewayHelper.get_gateway_client(@client.id, @gateway_nonce.gateway_type)
    end

    # add_payment_method_params for api call
    #
    # * Author: Aman
    # * Date: 30/05/2019
    # * Reviewed By:
    #
    # @return [Hash]
    #
    def add_payment_method_params
      apmp = {}
      apmp[:customer_id] = @customer_id
      apmp[:payment_method_nonce] = @gateway_nonce.nonce
      apmp
    end

    # Create Payment Method
    #
    # * Author: Aman
    # * Date: 30/05/2019
    # * Reviewed By:
    #
    # @return [Result::Base]
    #
    # Sets @payment_method
    #
    def create_payment_method
      resp = YAML.dump(@add_payment_method_resp.data[:result])
      add_payment_method_details = YAML.load(resp, safe: true)

      @payment_method = PaymentMethod.create!(
          client_id: @client.id,
          customer_id: @customer_id,
          gateway_type: @gateway_nonce.gateway_type,
          payment_method: GlobalConstant::PaymentMethod.card_payment_method,
          details: add_payment_method_details,
          token: add_payment_method_details["payment_method"]["token"],
          is_default: true
      )

      success
    end

    # Mark Default False To Other Payments Method
    #
    # * Author: Aman
    # * Date: 30/05/2019
    # * Reviewed By:
    #
    # @return [Result::Base]
    #
    # Sets payment_method
    #
    def mark_default_false_to_other_payment_methods
      payment_methods = PaymentMethod.where(customer_id: @customer_id).all
      payment_methods.all.each do |payment_method|
        payment_method.is_default = nil
        payment_method.save if payment_method.changed?
      end
      success
    end

    # Format service response
    #
    # * Author: Aman
    # * Date: 30/05/2019
    # * Reviewed By:
    #
    def service_response_data
      {
          payment_method_response: @payment_method.details
      }
    end

  end
end