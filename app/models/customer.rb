class Customer < EstablishOstPaymentClientDbConnection

  serialize :details, Hash

  enum status: {
      GlobalConstant::Customer.active_status => 1,
      GlobalConstant::Customer.inactive_status => 2
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
    MemcacheKey.new('customer.get_by_id')
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
  def self.get_from_memcache(id)
    memcache_key_object = Customer.get_memcache_key_object
    Memcache.get_set_memcached(memcache_key_object.key_template % {id: id}, memcache_key_object.expiry) do
      Customer.where(id: id).first
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
    customer_memcache_key = Customer.get_memcache_key_object.key_template % {id: self.id}
    Memcache.delete(customer_memcache_key)
  end

end
