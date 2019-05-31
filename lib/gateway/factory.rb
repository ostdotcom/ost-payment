module Gateway

  class Factory

    def initialize(params)
      @gateway_type = params[:gateway_type].titleize
    end

    def perform
      "Gateway::#{@gateway_type}".constantize
    end


  end

end