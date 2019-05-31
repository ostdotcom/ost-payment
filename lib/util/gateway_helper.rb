module Util
  module GatewayHelper

    # Util::GatewayHelper

    # gateway type
    #
    # * Author: Aman
    # * Date: 30/05/2019
    # * Reviewed By:
    #
    # @return [String]
    #
    #
    def get_gateway_client(client_id, gateway_type)
      @gateway_client ||= begin
        gateway_details = GatewayDetail.get_from_memcache(client_id, gateway_type)
        return nil if gateway_details.blank?

        gc = "Gateway::#{gateway_type.camelize}".constantize.new(gateway_details.decrypted_details)
        gc
      end

    end


  end
end