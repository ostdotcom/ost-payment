class Gateway::Factory::GenerateGatewayToken < ServicesBase

  def initialize(params)
    super(params)

    initialize_gateway_class

  end

  def perform

    r  = validate

    return r unless r.success?

    gateway_instance = @gateway_class.new(@params)

    gateway_instance.perform
  end


end
