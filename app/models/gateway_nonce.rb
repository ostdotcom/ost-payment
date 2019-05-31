class GatewayNonce < EstablishOstPaymentClientDbConnection

  enum status: {
      GlobalConstant::GatewayNonce.active_status => 1,
      GlobalConstant::GatewayNonce.used_status => 2,
      GlobalConstant::GatewayNonce.inactive_status => 3
  }

  after_commit :memcache_flush

  has_one :ost_payment_token

  # Get Key Object
  #
  # * Author: Aman
  # * Date: 30/05/2019
  # * Reviewed By:
  #
  # @return [MemcacheKey] Key Object
  #
  def self.get_memcache_key_object
    MemcacheKey.new('gateway_nonce.get_by_uuid')
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
  def self.get_from_memcache(uuid)
    memcache_key_object = GatewayNonce.get_memcache_key_object
    Memcache.get_set_memcached(memcache_key_object.key_template % {uuid: uuid}, memcache_key_object.expiry) do
      gn = GatewayNonce.where(uuid: uuid).first
      gn.ost_payment_token
      gn
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
    memcache_key = GatewayNonce.get_memcache_key_object.key_template % {uuid: self.uuid}
    Memcache.delete(memcache_key)
  end

end
