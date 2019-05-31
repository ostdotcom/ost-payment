class GatewayDetail < EstablishOstPaymentClientDbConnection

  serialize :details, Hash

  enum status: {
      GlobalConstant::GatewayDetail.active_status => 1,
      GlobalConstant::GatewayDetail.inactive_status => 2
  }

  attr_accessor :decrypted_details

  after_commit :memcache_flush


  # Get Key Object
  #
  # * Author: Aman
  # * Date: 30/05/2019
  # * Reviewed By:
  #
  # @return [MemcacheKey] Key Object
  #
  def self.get_memcache_key_object
    MemcacheKey.new('gateway_detail.get_active_by_client_id_and_g_type')
  end

  # Get/Set Memcache data for User
  #
  # * Author: Aman
  # * Date: 30/05/2019
  # * Reviewed By:
  #
  # @param [Integer] user_id - user id
  #
  # @return [AR] User object
  #
  def self.get_from_memcache(client_id, gateway_type)
    memcache_key_object = GatewayDetail.get_memcache_key_object
    Memcache.get_set_memcached(memcache_key_object.key_template % {
        client_id: client_id,
        gateway_type: gateway_type
    }, memcache_key_object.expiry) do

      gd = GatewayDetail.where(client_id: client_id,
                               gateway_type: gateway_type,
                               status: GlobalConstant::GatewayDetail.active_status).first
      gd.decrypted_details = gd.details if gd.present?
      gd
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
    memcache_key = GatewayDetail.get_memcache_key_object.key_template % {client_id: client_id,
                                                                                  gateway_type: gateway_type}
    Memcache.delete(memcache_key)
  end

end
