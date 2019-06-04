class RestApi::V0::OstPaymentController <  RestApi::V0::BaseController

  # Generate Token
  #
  # * Author: Aman
  # * Date: 30/05/2019
  # * Reviewed By:
  #
  def generate_token
    @service_response = RestApi::GenerateToken.new(params).perform
    format_service_response
  end

  # Add Payment Method
  #
  # * Author: Tejas
  # * Date: 30/05/2019
  # * Reviewed By:
  #
  def add_payment_method
    @service_response = RestApi::AddPaymentMethod.new(params).perform
    format_service_response
  end

  # Sale
  #
  # * Author: Mayur
  # * Date: 30/05/2019
  # * Reviewed By:
  #
  def sale
    @service_response = RestApi::Sale.new(params).perform
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