# frozen_string_literal: true
module GlobalConstant

  class PaymentMethod

    class << self

      ### Payment Method Start ###

      def card_payment_method
        'card'
      end

      def paypal_payment_method
        'paypal'
      end

      ### Payment Method End ###

    end

  end

end
