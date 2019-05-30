class Webapps::GatewayController < ApplicationController

  before_action :cors_handling


  def generate_gateway_token
    service_response = Webapps::Gateway::Factory::GenerateGatewayToken.new(params).perform
    render_api_response(service_response)
  end

  def save_nonce

  end

  def cors_handling

  end



















end