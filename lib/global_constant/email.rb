# frozen_string_literal: true
module GlobalConstant

  class Email

    class << self

      def default_from
        @default_from ||= case Rails.env
                            when 'staging'
                              'payment.stagingnotifier@ost.com'
                            when 'development'
                              'payment.stagingnotifier@ost.com'
                            else
                              'payment.notifier@ost.com'
                          end
      end

      def default_to
        ['bala@ost.com', 'sunil@ost.com', 'aman@ost.com', 'tejas@ost.com', 'mayur@ost.com',
         'somashekhar@ost.com', 'yogesh@ost.com']
      end

      def default_pm_to
        ['francesco@ost.com']
      end

      def subject_prefix
        "OSTP #{Rails.env} : "
      end

    end

  end

end
