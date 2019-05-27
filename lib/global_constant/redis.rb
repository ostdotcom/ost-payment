# frozen_string_literal: true
module GlobalConstant

  class Redis

    def self.url
      Base.redis_config['url'].to_s
    end

    def self.sidekiq_namespace
      "ost_payment_api_sidekiq:#{Rails.env}"
    end

  end

end
