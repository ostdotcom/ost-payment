module Authentication::ApiRequest

  EXPIRATION_WINDOW_V1 = 5.minutes

  class V0 < Base

    def initialize(params)
      super
    end

    # Get expiry window
    #
    # * Author: Aman
    # * Date:
    # * Reviewed By:
    #
    def expiry_window
      EXPIRATION_WINDOW_V1
    end

  end
end