module RestApi
  module Customer
    class Create < ServicesBase

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
      # @return [RestApi::Customer::Create]
      #
      def initialize(params)
        super(params)

        @customer_details = {}
        @gateway_nonce, @ost_payment_token = nil, nil
        @customer, @gateway_customer_associations = nil, []
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

        r = create_customer
        return r unless r.success?

        r = create_customer_in_gateway
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
      def create_customer
        @customer = ::Customer.create!(client_id: @client.id,
                                       status: GlobalConstant::Customer.active_status,
                                       details: @customer_details
        )
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
      def create_customer_in_gateway
        return success if @payment_nonce_uuid.blank?

        r = "GatewayManagement::Customer::Create::#{@gateway_nonce.gateway_type.camelize}".constantize.
            new(customer: @customer, client_id: @client.id, gateway_nonce: @gateway_nonce).perform

        return r unless r.success?

        @gateway_customer_associations = [r.data[:gateway_customer_association]]

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
            gateway_customer_associations: @gateway_customer_associations.map{|x| x.get_hash}
        }

      end


    end
  end
end