module Util
  module GatewayHelper

    # Util::GatewayHelper

    # gateway client
    #
    # * Author: Aman
    # * Date: 30/05/2019
    # * Reviewed By:
    #
    # @return [String]
    #
    #
    def get_gateway_client(params)
      client_id = params[:client_id]
      gateway_type = params[:gateway_type]
      gateway_detail = params[:gateway_detail]

      @gateway_client ||= begin
                            if gateway_detail.blank?
                              gateway_detail = GatewayDetail.get_from_memcache(client_id, gateway_type)
                              return nil if gateway_detail.blank?
                            end

        gc = "Gateway::#{gateway_type.camelize}".constantize.new(gateway_details.decrypted_details)
        # gc = "Gateway::#{gateway_type.camelize}".constantize.new({})
        gc
      end

    end


  end
end