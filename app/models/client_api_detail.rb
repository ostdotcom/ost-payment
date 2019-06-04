class ClientApiDetail < EstablishOstPaymentClientDbConnection

  enum status: {
      GlobalConstant::ClientApiDetail.active_status => 1,
      GlobalConstant::ClientApiDetail.inactive_status => 2
  }

  scope :non_deleted, -> {
    where(status: [GlobalConstant::ClientApiDetail.active_status])
  }

  attr_accessor :decrypted_api_secret
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
    MemcacheKey.new('client.api_key_details')
  end

  # Get/Set Memcache data for Client from api key
  #
  # * Author: Aman
  # * Date: 27/05/2019
  # * Reviewed By:
  #
  # @param [String] api_key - client api_key
  #
  # @return [Hash] Client object & client api detail obj
  #
  def self.get_client_data(api_key)
    r = Memcache.get_set_memcached(get_memcache_key_object.key_template % {api_key: api_key}, get_memcache_key_object.expiry) do
      client_api_detail_obj = ClientApiDetail.non_deleted.where(api_key: api_key).first
      return {} if client_api_detail_obj.blank?

      client_obj = Client.where(id: client_api_detail_obj.client_id).first

      r = Aws::Kms.new('saas', 'saas').decrypt(client_obj.salt)
      client_obj.decrypted_salt = r.data[:plaintext] if r.success?

      r = LocalCipher.new(client_obj.decrypted_salt).decrypt(client_api_detail_obj.api_secret)
      client_api_detail_obj.decrypted_api_secret = r.data[:plaintext] if r.success?

      {client: client_obj, client_api_detail: client_api_detail_obj}
    end
    r || {}
  end

  # Flush Memcache for a given client
  #
  # * Author: Aman
  # * Date: 27/05/2019
  # * Reviewed By:
  #
  def self.memcache_flush_of_client(client_id)
    api_keys = ClientApiDetail.non_deleted.where(client_id: client_id).all.pluck(:api_key)

    api_keys.each do |api_key|
      client_api_details_memcache_key = ClientApiDetail.get_memcache_key_object.key_template % {api_key: api_key}
      Memcache.delete(client_api_details_memcache_key)
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
    client_api_details_memcache_key = ClientApiDetail.get_memcache_key_object.key_template % {api_key: self.api_key}
    Memcache.delete(client_api_details_memcache_key)

    return if self.previous_changes["api_key"].blank?

    old_api_key = self.previous_changes["api_key"].first
    client_api_details_memcache_key = ClientApiDetail.get_memcache_key_object.key_template % {api_key: old_api_key}
    Memcache.delete(client_api_details_memcache_key)
  end


end

