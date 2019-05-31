class RestApi::V0::OstPaymentController <  RestApi::V0::BaseController


  def generate_token
    @service_response = RestApi::GenerateToken.new(params).perform
    format_service_response
  end

  private

  # Get formatter class
  #
  # * Author: Aman
  # * Date:
  # * Reviewed By:
  #
  def get_formatter_class
    Formatter::V0::OstPayment
  end

end