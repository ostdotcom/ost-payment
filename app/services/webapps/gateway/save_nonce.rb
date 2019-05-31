module Webapps

  module Gateway

    class SaveNonce < ServicesBase
      # Webapps::Gateway::SaveNonce

      # Initialize
      #
      # * Author: Tejas
      # * Date: 31/05/2019
      # * Reviewed By:
      #
      # @param [String] gateway_nonce (mandatory) - gateway nonce
      # @param [AR] ost_payment_token (mandatory) - ost payment token obj
      # @param [String] gateway_type (mandatory) - gateway type
      #
      # Sets @gateway_nonce_record
      #
      # @return [Webapps::Gateway::SaveNonce]
      #
      def initialize(params)
        super(params)
        @gateway_nonce = @params[:gateway_nonce]
        @ost_payment_token = @params[:ost_payment_token]
        @gateway_type = @params[:gateway_type]
        @gateway_nonce_record = nil
      end

      # Perform
      #
      # * Author: Tejas
      # * Date: 31/05/2019
      # * Reviewed By:
      #
      # @return [Result::Base]
      #
      def perform
        r = validate_and_sanitize
        return r unless r.success?

        r = create_entry_in_gateway_nonce
        return r unless r.success?

        success_with_data(api_response)
      end


      # Validate and sanitize
      #
      # * Author: Aman
      # * Date: 30/05/2019
      # * Reviewed By:
      #
      # @return [Result::Base]
      #
      def validate_and_sanitize
        r = validate
        return r unless r.success?

        r = validate_gateway_nonce
        return r unless r.success?

        r = validate_gateway_type
        return r unless r.success?

        success
      end

      # Validate Gateway Nonce
      #
      # * Author: Tejas
      # * Date: 31/05/2019
      # * Reviewed By:
      #
      # @return [Result::Base]
      #
      def validate_gateway_nonce
        return error_with_identifier('invalid_api_params',
                                     'w_g_sn_vgn_1',
                                     ['invalid_gateway_nonce']
        ) unless Util::CommonValidateAndSanitize.is_string?(@gateway_nonce)
        success
      end

      # Validate Gateway Type
      #
      # * Author: Tejas
      # * Date: 31/05/2019
      # * Reviewed By:
      #
      # @return [Result::Base]
      #
      def validate_gateway_type
        return error_with_identifier('invalid_api_params',
                                     'w_g_sn_vgn_2',
                                     ['invalid_gateway_type']
        ) unless GlobalConstant::GatewayType.is_valid_gateway_type?(@gateway_type)
        success
      end

      # Create Entry In Gateway Nonce
      #
      # * Author: Tejas
      # * Date: 31/05/2019
      # * Reviewed By:
      #
      # @sets @gateway_nonce_record
      #
      # @return [Result::Base]
      #
      def create_entry_in_gateway_nonce
        @gateway_nonce_record = GatewayNonce.new(
            uuid: get_uuid,
            ost_payment_token_id: @ost_payment_token.id,
            nonce: @gateway_nonce,
            status: GlobalConstant::GatewayNonce.active_status,
            gateway_type: @gateway_type
        )
        @gateway_nonce_record.save!
        success
      end

      # Get UUID
      #
      # * Author: Tejas
      # * Date: 31/05/2019
      # * Reviewed By:
      #
      # @return [String]
      #
      def get_uuid
        rand_no = rand.to_s[2..6].to_s #generate 5 digit random string
        timestamp = Time.now.to_f.to_s

        Digest::SHA256.hexdigest(rand_no + '-' + timestamp)
      end

      # Api Response
      #
      # * Author: Tejas
      # * Date: 31/05/2019
      # * Reviewed By:
      #
      # @return [Hash]
      #
      def api_response
        {
            payment_nonce_uuid: @gateway_nonce_record.uuid,
            gateway_type: @gateway_type
        }
      end

    end

  end

end