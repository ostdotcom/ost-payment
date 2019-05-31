class RestApi::BaseController < ApplicationController

  before_action :authenticate_request

  private

  # Authenticate client request by validating api credentials
  #
  # * Author: AMAN
  # * Date:
  # * Reviewed By:
  #
  def authenticate_request
    Rails.logger.info("authenticate_rest_api_request")

    request_parameters = request.request_method == 'GET' ? request.query_parameters : request.request_parameters

    service_response = authenticator.new(
        params.merge({
                         request_parameters: request_parameters,
                         url_path: request.path
                     })
    ).perform

    if service_response.success?
      # Set client id
      params[:client] = service_response.data[:client]

      # Remove sensitive data
      service_response.data = {}
    else
      render_api_response(service_response)
    end
  end

  # Format response got from service.
  #
  # * Author: Aman
  # * Date:
  # * Reviewed By:
  #
  def format_service_response
    formatted_response = @service_response

    if formatted_response.success?
      formatted_response.data = get_formatter_class.send(params['action'], formatted_response.data.dup)
    end

    render_api_response(formatted_response)
  end


  # Get formatter class
  #
  # * Author:Aman
  # * Date:
  # * Reviewed By:
  #
  def get_formatter_class
    fail 'get_formatter_class method is not override'
  end



end