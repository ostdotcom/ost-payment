module RestApi
  module Customer
    class Base < ServicesBase

      # Initialize
      #
      # * Author: Aman
      # * Date: 30/05/2019
      # * Reviewed By:
      #
      # @param [AR] client (mandatory) - client obj
      # @param [String] first_name (optional) - First name of customer
      # @param [String] last_name (optional) - Last name of customer
      # @param [String] company (optional) - company of customer
      # @param [String] email (optional) - email id of customer
      # @param [String] phone (optional) - phone number of customer
      # @param [String] fax (optional) - fax of customer
      # @param [String] website (optional) - website of customer
      # @param [String] payment_nonce_uuid (optional) - payment_nonce_uuid of customer
      #
      # Sets gateway_nonce, ost_payment_token
      #
      # @return [RestApi::Customer::Base]
      #
      def initialize(params)
        super(params)
        @client = @params[:client]

        @first_name = @params[:first_name]
        @last_name = @params[:last_name]
        @company = @params[:company]
        @email = @params[:email]
        @phone = @params[:phone]
        @fax = @params[:fax]
        @website = @params[:website]
        @payment_nonce_uuid = @params[:payment_nonce_uuid]

        @customer_details = {}
        @gateway_nonce, @ost_payment_token = nil, nil

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
        fail 'unimplemented perform'
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

        r = validate_parameters
        return r unless r.success?

        success
      end

      # Validate input params
      #
      # * Author: Aman
      # * Date: 30/05/2019
      # * Reviewed By:
      #
      # @return [Result::Base]
      #
      # Sets customer_details
      #
      def validate_parameters
        r = validate_payment_nonce_uuid
        return r unless r.success?

        error_identifiers = []

        error_identifiers << 'invalid_first_name' if @first_name.present? &&
            (!Util::CommonValidateAndSanitize.is_string?(@first_name) || @first_name.length > 255)

        error_identifiers << 'invalid_last_name' if @last_name.present? &&
            (!Util::CommonValidateAndSanitize.is_string?(@last_name) || @last_name.length > 255)

        error_identifiers << 'invalid_company' if @company.present? &&
            (!Util::CommonValidateAndSanitize.is_string?(@company) || @company.length > 255)

        error_identifiers << 'invalid_email' if @email.present? &&
            (!Util::CommonValidateAndSanitize.is_valid_email?(@email))


        error_identifiers << 'invalid_phone' if @phone.present? &&
            (!Util::CommonValidateAndSanitize.is_string?(@phone) || @phone.length > 255)

        error_identifiers << 'invalid_fax' if @fax.present? &&
            (!Util::CommonValidateAndSanitize.is_string?(@fax) || @fax.length > 255)

        error_identifiers << 'invalid_website' if @website.present? &&
            (!Util::CommonValidateAndSanitize.is_valid_domain?(@website) || @website.length > 255)


        return error_with_identifier('invalid_api_params',
                                     'ra_c_c_vp_1',
                                     error_identifiers
        ) if error_identifiers.present?

        @customer_details[:first_name] = @first_name if @first_name.present?
        @customer_details[:last_name] = @last_name if @last_name.present?
        @customer_details[:company] = @company if @company.present?
        @customer_details[:email] = @email if @email.present?
        @customer_details[:phone] = @phone if @phone.present?
        @customer_details[:fax] = @fax if @fax.present?
        @customer_details[:website] = @website if @website.present?

        success
      end


      # Validate payment_nonce_uuid if present
      #
      # * Author: Aman
      # * Date: 30/05/2019
      # * Reviewed By:
      #
      # @return [Result::Base]
      #
      # Sets gateway_nonce, ost_payment_token
      #
      def validate_payment_nonce_uuid
        return success if @payment_nonce_uuid.blank?

        return error_with_identifier('invalid_api_params',
                                     'ra_c_c_vpnu_1',
                                     ['invalid_payment_nonce_uuid']
        ) unless Util::CommonValidateAndSanitize.is_string?(@payment_nonce_uuid)


        @gateway_nonce = GatewayNonce.get_from_memcache(@payment_nonce_uuid)

        return error_with_identifier('invalid_api_params',
                                     'ra_c_c_vpnu_2',
                                     ['invalid_payment_nonce_uuid']
        ) if @gateway_nonce.blank?

        @ost_payment_token = @gateway_nonce.ost_payment_token

        return error_with_identifier('invalid_api_params',
                                     'ra_c_c_vpnu_3',
                                     ['invalid_payment_nonce_uuid']
        ) if (@ost_payment_token.client_id != @client.id) ||
            (@gateway_nonce.status != GlobalConstant::GatewayNonce.active_status) ||
            (@ost_payment_token.customer_id.present?)

        success
      end


      # Format service response
      #
      # * Author: Aman
      # * Date: 30/05/2019
      # * Reviewed By:
      #
      def service_response_data
        fail 'unimplemented method service_response_data'
      end


    end
  end
end