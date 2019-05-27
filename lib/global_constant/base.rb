# frozen_string_literal: true
module GlobalConstant

  class Base

    def self.memcache_config
      @memcache_config ||= fetch_config.fetch('memcached', {}).with_indifferent_access
    end

    def self.aws
      @aws ||= fetch_config.fetch('aws', {}).with_indifferent_access
    end

    def self.kms
      @kms ||= fetch_config.fetch('kms', {}).with_indifferent_access
    end

    def self.redis_config
      @redis_config ||= fetch_config.fetch('redis', {})
    end


    def self.environment_name
      Rails.env
    end

    private

    def self.fetch_config
      @f_config ||= begin
        template = ERB.new File.new("#{Rails.root}/config/constants.yml").read
        YAML.load(template.result(binding)).fetch('constants', {}) || {}
      end
    end
  end

end