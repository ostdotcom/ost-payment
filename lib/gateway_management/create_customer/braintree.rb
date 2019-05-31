module GatewayManagement::CreateCustomer
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
    def create_params
      customer.details
    end


  end
end