class OstPaymentToken < EstablishOstPaymentClientDbConnection

  enum status: {
      GlobalConstant::OstPaymentToken.active_status => 1,
      GlobalConstant::OstPaymentToken.inactive_status => 2
  }

  DEFAULT_EXPIRY = 3.hours.to_i

  include AttributeParserConcern

  # Create a new token
  #
  # * Author: Aman
  # * Date: 24/01/2019
  # * Reviewed By:
  #
  # @returns [String]
  #
  def self.generate_token
    SecureRandom.hex(64) + Time.now.to_f.to_s + rand(1000000).to_s
  end

  # # Columns to be removed from the hashed response
  # #
  # # * Author: Aman
  # # * Date: 28/09/2018
  # # * Reviewed By:
  # #
  # def self.restricted_fields
  #   [:token]
  # end

end
