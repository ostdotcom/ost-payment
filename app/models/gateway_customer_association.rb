class GatewayCustomerAssociation < EstablishOstPaymentClientDbConnection

  enum gateway_type: GlobalConstant::GatewayType.gateway_types_enum

  enum status: {
      GlobalConstant::GatewayCustomerAssociation.active_status => 1,
      GlobalConstant::GatewayCustomerAssociation.inactive_status => 2
  }


  after_commit :memcache_flush
  include AttributeParserConcern

  # Get Key Object
  #
  # * Author: Aman
  # * Date: 30/05/2019
  # * Reviewed By:
  #
  # @return [MemcacheKey] Key Object
  #
  def self.get_memcache_key_object
    MemcacheKey.new('gateway_customer_association.get_all_by_customer_id')
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
  def self.get_all_from_memcache(customer_id)
    memcache_key_object = GatewayCustomerAssociation.get_memcache_key_object
    Memcache.get_set_memcached(memcache_key_object.key_template % {customer_id: customer_id}, memcache_key_object.expiry) do
      GatewayCustomerAssociation.where(customer_id: customer_id,
                                       status: GlobalConstant::GatewayCustomerAssociation.active_status).all.to_a
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
    memcache_key = GatewayCustomerAssociation.get_memcache_key_object.key_template % {customer_id: self.customer_id}
    Memcache.delete(memcache_key)
  end

end
