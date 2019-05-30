class Gateway::Braintree::GenerateGatewayToken < ServicesBase

  def initialize(params)

  end

  def perform

    r = validate_braintree_params

    return r unless r.success?

    Billing::Gateways::BraintreeGateway.generate_token(@params)
  end


  def validate_braintree_params
    # add braintree specific validations if needed
    success
  end



end
