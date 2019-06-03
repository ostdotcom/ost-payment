class Webapps::BaseController < ApplicationController

  before_action :authenticate_request

  private

  # Authenticate request by validating ost payment token
  #
  # * Author: Aman
  # * Date:
  # * Reviewed By:
  #
  def authenticate_request
    Rails.logger.info("authenticate_webapps_request")

    service_response = authenticator.new(params).perform

    if service_response.success?
      params[:ost_payment_token] = service_response.data[:ost_payment_tokens]
      # Remove sensitive data
      service_response.data = {}
    else
      render_api_response(service_response)
    end
  end

end