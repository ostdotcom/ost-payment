module Util

  module ResultHelper

    # All methods of this module are common short hands used for

    # Success
    #
    # * Author:
    # * Date:
    # * Reviewed By:
    #
    # @return [Result::Base]
    #
    def success
      success_with_data({})
    end

    # Success with data
    #
    # * Author:
    # * Date:
    # * Reviewed By:
    #
    # @param [Hash] data (mandatory) - data to be sent in the response
    #
    # @return [Result::Base]
    #
    def success_with_data(data)
      # Allow only Hash data to pass ahead
      data = {} unless Util::CommonValidateAndSanitize.is_hash?(data)

      Result::Base.success({
                               data: data
                           })
    end

    # Error with Action
    #
    # * Author:
    # * Date:
    # * Reviewed By:
    #
    # @param [String] internal_code (mandatory) - internal code
    # @param [String] message (mandatory) - error message
    # @param [String] display_text (mandatory) - error display text
    # @param [String] action (mandatory) - error action
    # @param [Hash] data (mandatory) - data
    # @param [Hash] error_data (mandatory) - error data
    #
    # @return [Result::Base]
    #
    def error_with_data(internal_code, message, display_text, action, data, error_data = {})
      warn "[DEPRECATION] `error_with_data` is deprecated.   Please use `error_with_identifier` instead."
      Result::Base.error(
          {
              error: internal_code,
              error_message: message,
              error_data: error_data,
              error_action: action,
              error_display_text: display_text,
              data: data
          }
      )
    end

    # Error with Identifier
    #
    # * Author:
    # * Date:
    # * Reviewed By:
    #
    # @param [String] api_error_code (mandatory) - Error code for sending Api response
    # @param [String] internal_code (mandatory) - Internal error code
    # @param [Array] params_error_identifiers (Optional) - Group of error codes to send in Api response
    # @param [String] display_text (Optional) - Error Display Text for web.
    #         blank value will send blank display text, while nil will send the api_error_code msg
    #
    # @return [Result::Base]
    #
    def error_with_identifier(api_error_code, internal_code, params_error_identifiers = [], display_text=nil, params_error_data={})
      Result::Base.error(
          {
              api_error_code: api_error_code,
              error: internal_code,
              params_error_identifiers: params_error_identifiers,
              error_display_text: display_text,
              error_data: params_error_data
          }
      )
    end

    # Exception with action and data
    #
    # * Author:
    # * Date:
    # * Reviewed By:
    #
    # @param [Exception] e (mandatory) - Exception object
    # @param [String] code (mandatory) - error code
    # @param [String] message (mandatory) - error message
    # @param [String] display_text (mandatory) - display text
    # @param [String] action (mandatory) - action
    # @param [Hash] data (mandatory) - error data
    #
    # @return [Result::Base]
    #
    def exception_with_data(e, code, message, display_text, action, data)
      Result::Base.exception(
        e, {
        error: code,
        error_message: message,
        error_action: action,
        error_display_text: display_text,
        data: data
      })
    end

    # Current Time
    #
    # * Author:
    # * Date:
    # * Reviewed By:
    #
    def current_time
      @c_t ||= Time.now
    end

    # Current Time Stamp
    #
    # * Author:
    # * Date:
    # * Reviewed By:
    #
    def current_timestamp
      @c_tstmp ||= current_time.to_i
    end

    # Success with data
    #
    # * Author:
    # * Date:
    # * Reviewed By:
    #
    # @param [Hash] data (mandatory) - data to be sent in the response
    #
    # @return [Result::Base]
    #
    def success_result(data)
      # Allow only Hash data to pass ahead
      data = {} unless Util::CommonValidateAndSanitize.is_hash?(data)

      Result::Base.success({
                               data: data
                           })
    end

    # Deprecated error with internal code
    #
    # * Author:
    # * Date:
    # * Reviewed By:
    #
    # @param [String] code (mandatory) - error code
    # @param [String] msg (mandatory) - error message
    # @param [Integer] http_code (mandatory) - http code
    # @param [String] data (optional) - error data
    # @param [Hash] extended_data[:tracking_data] (optional) - tracking data to be sent in the response
    # @param [Hash] extended_data[:segmentation_data] (optional) - segmentation data to be sent in the response
    #
    # @return [Result::Base] returns an object of Result::Base class
    #
    def deprecated_error_with_internal_code(internal_code, msg, http_code, data = {}, error_data = {}, error_display_text= nil)
      warn "[DEPRECATION] `deprecated_error_with_internal_code` is deprecated.
            Please use `error_with_internal_code` instead."

      Result::Base.error(
          {
              error: internal_code,
              error_message: msg,
              error_display_text: error_display_text || msg,
              data: data,
              http_code: http_code,
              error_data: error_data
          })
    end



    # Error with internal code
    #
    # * Author:
    # * Date:
    # * Reviewed By:
    #
    # @param [String] internal_code (mandatory) - internal code
    # @param [String] error_msg (mandatory) - error message
    # @param [Integer] http_code (mandatory) - internal code, on which conditions can be made
    # @param [String] data (optional) - data
    # @param [Array] error_data (optional) - error data
    # @param [Hash] error_display_text (optional) - error display text
    #
    # @return [Result::Base] returns an object of Result::Base class
    #
    def error_with_internal_code(internal_code, error_msg, http_code, data = {}, error_data = [], error_display_text= nil)
      error_hash = {}
      error_data.each do |err|
        param = err['parameter']
        msg = err['msg']
        error_hash[param] = msg
      end

      deprecated_error_with_internal_code(internal_code, error_msg, http_code, data, error_hash, error_display_text)
    end

    # Exception with internal code
    #
    # * Author:
    # * Date:
    # * Reviewed By:
    #
    # @param [Exception] e (mandatory) - Exception object
    # @param [String] internal_code (mandatory) - error code
    # @param [String] msg (mandatory) - error message
    # @param [Integer] http_code (mandatory) - internal code, on which conditions can be made
    # @param [String] data (optional) - error data
    # @param [String] error_display_text (optional) - general error message for response
    #
    # @return [Result::Base] returns an object of Result::Base class
    #
    def exception_with_internal_code(e, internal_code, msg, http_code, data = {}, error_display_text=nil)

      Result::Base.exception(
          e, {
          error: internal_code,
          error_message: msg,
          data: data,
          http_code: http_code,
          error_display_text: error_display_text || msg,
      }
      )
    end

  end

end