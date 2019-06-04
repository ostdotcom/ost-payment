module Authentication::WebappsRequest

  class Base < ServicesBase

    # Initialize
    #
    # * Author: Aman
    # * Date:
    # * Reviewed By:
    #
    # @param [String] token (mandatory) -  ost payment token
    #
    # @return [Authentication::WebappsRequest::Base]
    #
    def initialize(params)
      super

      @token = @params[:token]

      @ost_payment_token = nil
    end

    # Perform
    #
    # * Author: Aman
    # * Date:
    # * Reviewed By:
    #
    # @return [Result::Base]
    #
    def perform

      r = validate_and_sanitize
      return r unless r.success?

      success_with_data({ost_payment_token: @ost_payment_token})

    end

    private

    # Validate and sanitize
    #
    # * Author: Aman
    # * Date:
    # * Reviewed By:
    #
    # @return [Result::Base]
    #
    # Sets @ost_payment_token
    #
    def validate_and_sanitize
      r = validate
      return invalid_credentials_response('a_wr_b_vas_1') unless r.success?

      @ost_payment_token = OstPaymentToken.get_from_memcache(@token)

      return invalid_credentials_response("a_wr_b_vas_2") if @ost_payment_token.blank? ||
          @ost_payment_token.status != GlobalConstant::OstPaymentToken.active_status

      return invalid_credentials_response("a_wr_b_vas_3") if (@ost_payment_token.creation_timestamp +
          @ost_payment_token.expiry_interval) < Time.now.to_i

      success
    end

    # Invalid credentials response
    #
    # * Author: Aman
    # * Date:
    # * Reviewed By:
    #
    # @return [Result::Base]
    #
    def invalid_credentials_response(internal_code)
      error_with_identifier('unauthorized_api_request', internal_code)
    end

  end

end