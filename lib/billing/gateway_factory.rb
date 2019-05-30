module Billing

  class GatewayFactory

    def initialize(params)
      @gateway_name = params[:gateway_name].titleize
    end

    def perform
      "Billing::Gateways::#{@gateway_name}Gateway".constantize
    end


  end

end