class Webapps::GatewayController < ApplicationController

  before_action :cors_handling

  # Generate Gateway Token
  #
  # * Author: Mayur
  # * Date: 31/05/2019
  # * Reviewed By:
  #
  def generate_gateway_token
    service_response = Webapps::Gateway::Factory::GenerateGatewayToken.new(params).perform
    render_api_response(service_response)
  end

  # Save Nonce
  #
  # * Author: Tejas
  # * Date: 31/05/2019
  # * Reviewed By:
  #
  def save_nonce
    service_response = Webapps::Gateway::SaveNonce.new(params).perform
    render_api_response(service_response)
  end

  def cors_handling

  end



















end