class OstPaymentToken < EstablishOstPaymentClientDbConnection

  enum status: {
      GlobalConstant::OstPaymentToken.active_status => 1,
      GlobalConstant::OstPaymentToken.inactive_status => 2
  }

  DEFAULT_EXPIRY = 3.hours.to_i

  after_commit :memcache_flush

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

  # Get Key Object
  #
  # * Author: Aman
  # * Date: 30/05/2019
  # * Reviewed By:
  #
  # @return [MemcacheKey] Key Object
  #
  def self.get_memcache_key_object
    MemcacheKey.new('ost_payment_token.get_by_token')
  end

  # Get/Set Memcache data for User
  #
  # * Author: Aman
  # * Date: 30/05/2019
  # * Reviewed By:
  #
  # @param [Integer] uuid - uuid
  #
  # @return [AR] User object
  #
  def self.get_from_memcache(token)
    memcache_key_object = OstPaymentToken.get_memcache_key_object
    Memcache.get_set_memcached(memcache_key_object.key_template % {token: token}, memcache_key_object.expiry) do
      OstPaymentToken.where(token: token).first
    end
  end

  private

  # Flush Memcache
  #
  # * Author: Aman
  # * Date: 30/05/2019
  # * Reviewed By:
  #
  def memcache_flush
    memcache_key = OstPaymentToken.get_memcache_key_object.key_template % {token: self.token}
    Memcache.delete(memcache_key)
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
