module RestApi
  class GenerateToken < ServicesBase

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
    # @return [RestApi::GenerateToken]
    #
    def initialize(params)
      super(params)
      @client = @params[:client]
      @customer_id = @params[:customer_id]

      @customer, @ost_payment_token = nil, nil
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

      create_ost_payment_token

      success_with_data({ost_payment_token: @ost_payment_token.get_hash})
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

      r = validate_customer
      return r unless r.success?

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
                                   'ra_gt_vc_1',
                                   ['invalid_customer_id']
      ) unless Util::CommonValidateAndSanitize.is_integer?(@customer_id)

      @customer_id = @customer_id.to_i
      @customer = Customer.get_from_memcache(@customer_id)
      return error_with_identifier('invalid_api_params',
                                   'ra_gt_vc_2',
                                   ['invalid_customer_id']
      ) if @customer.blank? || (@customer.client_id != @client.id) || (@customer.status != GlobalConstant::Customer.active_status)

      success
    end


    # Create a Ost Payment Token for client side sdk
    #
    # * Author: Aman
    # * Date: 30/05/2019
    # * Reviewed By:
    #
    # @return [Result::Base]
    #
    # Sets ost_payment_token
    #
    def create_ost_payment_token
      @ost_payment_token = OstPaymentToken.create(
          client_id: @client.id,
          customer_id: @customer_id,
          creation_timestamp: Time.now.to_i,
          expiry_interval: OstPaymentToken::DEFAULT_EXPIRY,
          token: OstPaymentToken.generate_token,
          status: GlobalConstant::OstPaymentToken.active_status
      )
    end

  end
end