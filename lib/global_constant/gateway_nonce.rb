# frozen_string_literal: true
module GlobalConstant

  class GatewayNonce

    class << self

      ### Status Start ###

      def active_status
        'active'
      end

      def used_status
        'used'
      end

      def inactive_status
        'inactive'
      end

      ### Status End ###

    end

  end

end
