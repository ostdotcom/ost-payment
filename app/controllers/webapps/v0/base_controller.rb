class Webapps::V0::BaseController < Webapps::BaseController

  private

  # Get authenticator route
  #
  # * Author:
  # * Date:
  # * Reviewed By:
  #
  def authenticator
    Authentication::WebappsRequest::V0
  end

end