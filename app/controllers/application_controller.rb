class ApplicationController < ActionController::API

  # Sanitize URL params
  include Sanitizer

  before_action :sanitize_params

  after_action :set_response_headers

  # this is the top-most wrapper - to catch all the exceptions at any level
  prepend_around_action :handle_exceptions_gracefully

  # Action not found handling. Also block "/"
  #
  # * Author:
  # * Date:
  # * Reviewed By:
  #
  def not_found
    r = Result::Base.error({
                               api_error_code: 'resource_not_found',
                               error: 'ac_1'
                           })
    render_api_response(r)
  end

  private

  # Method for sanitizing params
  #
  # * Author:
  # * Date:
  # * Reviewed By:
  #
  def sanitize_params
    sanitize_params_recursively(params)
  end

  # Get user agent
  #
  # * Author:
  # * Date:
  # * Reviewed By:
  #
  def http_user_agent
    # User agent is required for cookie validation
    request.env['HTTP_USER_AGENT'].to_s
  end

  # Get Ip Address
  #
  # * Author:
  # * Date:
  # * Reviewed By:
  #
  def ip_address
    request.remote_ip.to_s
  end

  # Render API Response
  #
  # * Author:
  # * Date:
  # * Reviewed By:
  #
  # @param [Result::Base] service_response is an object of Result::Base class
  #
  def render_api_response(service_response)
    # calling to_json of Result::Base
    response_hash = service_response.to_json
    http_status_code = response_hash.delete(:http_code)

    if response_hash[:err].present?
      response_hash[:err].delete(:error_extra_info)
      response_hash[:err].delete(:web_msg)
    end

    if !service_response.success? # && !Rails.env.development?

      response_hash.delete(:data)
    end
    (render plain: Oj.dump(response_hash, mode: :compat), status: http_status_code)
  end

  # Handle exceptions gracefully so that no exception goes unhandled.
  #
  # * Author:
  # * Date:
  # * Reviewed By:
  #
  def handle_exceptions_gracefully

    begin

      yield

    rescue => se

      Rails.logger.error("Exception in PAYMENT API: #{se.message}")
      ApplicationMailer.notify(
          body: {exception: {message: se.message, backtrace: se.backtrace}},
          data: {
              'params' => params
          },
          subject: 'Exception in PAYMENT API'
      ).deliver


      r = Result::Base.error({
                                 api_error_code: 'internal_server_error',
                                 error: 'swr',
                                 data: params
                             })
      render_api_response(r)

    end

  end


  # After action for setting the response headers
  #
  # * Author:
  # * Date:
  # * Reviewed By:
  #
  def set_response_headers
    response.headers["X-Robots-Tag"] = 'noindex, nofollow'
    response.headers["Content-Type"] = 'application/json; charset=utf-8'
  end

end
