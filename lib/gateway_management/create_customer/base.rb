module GatewayManagement::CreateCustomer
  class Base

    include Util::ResultHelper

    def initialize(params)
      @client_id = params[:client_id]
      @customer = params[:customer]
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
     r =  get_gateway_client

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
      fail 'unimplemented method gateway_type'
    end

    # gateway type
    #
    # * Author: Aman
    # * Date: 30/05/2019
    # * Reviewed By:
    #
    # @return [String]
    #
    #
    def gateway_class
      "Gateway::#{gateway_type.camelize}".constantize
    end

    # gateway type
    #
    # * Author: Aman
    # * Date: 30/05/2019
    # * Reviewed By:
    #
    # @return [String]
    #
    #
    def gateway_client
      @gateway_client ||= gateway_class.new(gateway_client_params)
    end

    # gateway type
    #
    # * Author: Aman
    # * Date: 30/05/2019
    # * Reviewed By:
    #
    # @return [Hash]
    #
    def gateway_client_params
      fail 'unimplemented method gateway_client_params'
    end

    # get gateway details obj
    #
    # * Author: Aman
    # * Date: 30/05/2019
    # * Reviewed By:
    #
    # @return [AR] GatewayDetail obj
    #
    def gateway_details
      @gateway_details ||= GatewayDetail.get_from_memcache(@client_id, gateway_type)
    end



  end
end