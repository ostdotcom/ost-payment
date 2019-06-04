module RestApi
  module Customer
    class Update < RestApi::Customer::Base

      # Initialize
      #
      # * Author: Aman
      # * Date: 30/05/2019
      # * Reviewed By:
      #
      # @param [AR] client (mandatory) - client obj
      # @param [AR] id (mandatory) - customer id
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
      # @return [RestApi::Customer::Create]
      #
      def initialize(params)
        super(params)

        @id = @params[:id]

        @customer_details = {}
        @gateway_nonce, @ost_payment_token = nil, nil
        @customer, @gateway_customer_associations = nil, {}
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

        r = update_customer
        return r unless r.success?

        get_gateway_customer_association

        r = update_customer_with_payment_nonce_in_gateway
        return r unless r.success?

        success_with_data(service_response_data)
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
        r = super
        return r unless r.success?

        r = validate_customer_id
        return r unless r.success?

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
      # Sets customer
      #
      def validate_customer_id

        return error_with_identifier('invalid_api_params',
                                     'ra_c_u_vci_1',
                                     ['invalid_id']
        ) unless Util::CommonValidateAndSanitize.is_positive_integer?(@id)


        @customer = ::Customer.get_from_memcache(@id)

        return error_with_identifier('invalid_api_params',
                                     'ra_c_u_vci_2',
                                     ['invalid_id']
        ) if @customer.blank? || @customer.status != GlobalConstant::Customer.active_status ||
            @customer.client_id != @client.id

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
      # Sets customer
      #
      def update_customer
        @customer.details.merge(@customer_details)
        @customer.save!

        success
      end

      # get all gateway customer association
      #
      # * Author: Aman
      # * Date: 30/05/2019
      # * Reviewed By:
      #
      # @return [Result::Base]
      #
      # Sets customer
      #
      def get_gateway_customer_association
        @gateway_customer_associations = GatewayCustomerAssociation.get_all_from_memcache(@id).index_by(&:gateway_type)
      end

      # Create a customer
      #
      # * Author: Aman
      # * Date: 30/05/2019
      # * Reviewed By:
      #
      # @return [Result::Base]
      #
      # Sets customer
      #
      def update_customer_with_payment_nonce_in_gateway
        return success if @gateway_customer_associations.blank? && @gateway_nonce.blank?

        @gateway_customer_associations.each do |gateway_type, gateway_customer_association|

          update_params = {customer: @customer, client_id: @client.id,
                           gateway_customer_association: gateway_customer_association}

          update_params[:gateway_nonce] = @gateway_nonce if @gateway_nonce.present? &&
              @gateway_nonce.gateway_type == gateway_type

          r = "GatewayManagement::Customer::Update::#{@gateway_nonce.gateway_type.camelize}".constantize.
              new(update_params).perform
          return r unless r.success?

        end

        return success if @gateway_nonce.blank?

        if @gateway_customer_associations[@gateway_nonce.gateway_type].blank?
          r = "GatewayManagement::Customer::Create::#{@gateway_nonce.gateway_type.camelize}".constantize.
              new(customer: @customer, client_id: @client.id, gateway_nonce: @gateway_nonce).perform

          return r unless r.success?

          @gateway_customer_associations[@gateway_nonce.gateway_type] = r.data[:gateway_customer_association]
        end

        @gateway_nonce.status = GlobalConstant::GatewayNonce.used_status
        @gateway_nonce.save!

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
            customer: @customer.get_hash,
            gateway_customer_associations: @gateway_customer_associations.values.map {|x| x.get_hash}
        }

      end


    end
  end
end