module GatewayManagement::Customer::Update
  class Braintree < Base

    def initialize(params)
      super(params)
    end

    # perform
    #
    # * Author: Aman
    # * Date: 30/05/2019
    # * Reviewed By:
    #
    # @return [Hash]
    #
    #
    def perform
      super
    end

    private


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
      GlobalConstant::GatewayType.braintree_gateway_type
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
    def update_params
      cp = @customer.details
      cp[:id] = @gateway_customer_association.gateway_customer_id
      cp[:payment_method_nonce] = @gateway_nonce if @gateway_nonce.present?
      cp
    end


  end
end