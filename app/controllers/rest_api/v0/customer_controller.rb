class RestApi::V0::CustomerController <  RestApi::V0::BaseController


  def create_customer
    @service_response = RestApi::Customer::Create.new(params).perform
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
    Formatter::V0::Customer
  end

end