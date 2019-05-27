module Util

  module SignalHandler

    # Register Handlers which would have this Cron Instance interuppt, kill etc ..
    #
    # * Author:
    # * Date:
    # * Reviewed By:
    #
    def register_signal_handlers
      puts "*** Adding handler register_signal_handlers ***"

      ['INT', 'QUIT', 'TERM'].each do |sig|
        Signal.trap(sig) {
          puts "\n\n\nTrapped - #{sig} ";
          GlobalConstant::SignalHandling.sigint_received!
        }
      end
    end

  end

end
