class Client < EstablishOstPaymentClientDbConnection

  enum status: {
      GlobalConstant::Client.active_status => 1,
      GlobalConstant::Client.inactive_status => 2
  }

  attr_accessor :decrypted_salt
  after_commit :memcache_flush


  # Get Key Object
  #
  # * Author: Aman
  # * Date: 27/05/2019
  # * Reviewed By:
  #
  # @return [MemcacheKey] Key Object
  #
  def self.get_memcache_key_object
    MemcacheKey.new('client.client_details')
  end

  # Get/Set Memcache data for Client from Id
  #
  # * Author: Aman
  # * Date: 27/05/2019
  # * Reviewed By:
  #
  # @param [Integer] client_id - client id
  #
  # @return [AR] Client object
  #
  def self.get_from_memcache(client_id)
    memcache_key_object = Client.get_memcache_key_object
    Memcache.get_set_memcached(memcache_key_object.key_template % {id: client_id}, memcache_key_object.expiry) do
      client = Client.where(id: client_id).first
      client
    end
  end

  private

  # Flush Memcache
  #
  # * Author: Aman
  # * Date: 27/05/2019
  # * Reviewed By:
  #
  def memcache_flush

    client_memcache_key = Client.get_memcache_key_object.key_template % {id: self.id}
    Memcache.delete(client_memcache_key)

    ClientApiDetail.memcache_flush_of_client(self.id)
  end

end