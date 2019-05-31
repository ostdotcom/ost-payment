module GatewayManagement::CreateCustomer
  class Braintree < Base

    def initialize(params)
      super

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
      r = super
      return r unless r.success?


      create_customer_in_gateway
    end




  end
end