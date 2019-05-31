class RestApi::V0::BaseController < RestApi::BaseController

  private

  # Get authenticator route
  #
  # * Author:
  # * Date:
  # * Reviewed By:
  #
  def authenticator
    Authentication::ApiRequest::V0
  end


end