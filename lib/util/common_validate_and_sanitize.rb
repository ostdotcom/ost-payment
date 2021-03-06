module Util

  class CommonValidateAndSanitize

    REGEX_EMAIL = /\A[A-Z0-9]+[A-Z0-9_%+-]*(\.[A-Z0-9_%+-]{1,})*@(?:[A-Z0-9](?:[A-Z0-9-]*[A-Z0-9])?\.)+[A-Z]{2,24}\Z/mi
    REGEX_DOMAIN_NAME = /\A[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}\z/i

    # check whether give object is integer or not
    #
    # * Author:
    # * Date:
    # * Reviewed By:
    #
    #  @return [Boolean] return true if object is integer
    #
    def self.is_integer?(object)
      return false unless is_float?(object)
      true if Integer(object) rescue false
    end

    # check whether give object is float or not
    #
    # * Author:
    # * Date:
    # * Reviewed By:
    #
    #  @return [Boolean] return true if object is float
    #
    def self.is_float?(object)
      true if Float(object) rescue false
    end

    # Is alpha numeric string
    #
    # * Author:
    # * Date:
    # * Reviewed By:
    #
    # @return [Boolean] returns a boolean
    #
    def self.is_alphanumeric?(name)
      name =~ /\A[A-Z0-9]+\Z/i
    end

    # check whether give object is String or not
    #
    # * Author:
    # * Date:
    # * Reviewed By:
    #
    #  @return [Boolean] return true if object is String
    #
    def self.is_string?(object)
      object.is_a?(String)
    end

    # check whether give object is integer and >=1
    #
    # * Author:
    # * Date:
    # * Reviewed By:
    #
    #  @return [Boolean] return true if object is integer
    #
    def self.is_positive_integer?(object)
      res = is_integer?(object)
      res = false if res && object.to_i <= 0
      res
    end

    # check whether give object is Hash or not
    #
    # * Author:
    # * Date:
    # * Reviewed By:
    #
    #  @return [Boolean] return true if object is Hash
    #
    def self.is_hash?(object)
      object.is_a?(Hash) || object.is_a?(ActionController::Parameters)
    end

    # check whether give object is Array or not
    #
    # * Author:
    # * Date:
    # * Reviewed By:
    #
    # @param kind(optional): value should be either integer or hash or boolean
    #
    #  @return [Boolean] return true if object is Array
    #
    def self.is_array?(object, data_kind = nil)
      return false unless object.is_a?(Array)

      is_valid_data_kind = true
      if data_kind
        object.each do |ele|
          case data_kind
            when 'string'
              is_valid_data_kind = self.is_string?(ele)
            when 'integer'
              is_valid_data_kind = self.is_integer?(ele)
            when 'hash'
              is_valid_data_kind = self.is_hash?(ele)
            when 'boolean'
              is_valid_data_kind = self.is_boolean?(ele)
            else
              puts 'invalid data_kind passed.'
              return is_valid_data_kind
          end
          break unless is_valid_data_kind
        end
      end
      is_valid_data_kind
    end

    # Is a Boolean class or not
    #
    # * Author:
    # * Date:
    # * Reviewed By:
    #
    # @return [Boolean] returns a boolean
    #
    def self.is_boolean?(object)
      object = true if object == 'true' || object == 1
      object = false if object == 'false' || object == 0

      object.is_a?(TrueClass) || object.is_a?(FalseClass)
    end

    # Is the Email a Valid Email
    #
    # * Author:
    # * Date:
    # * Reviewed By:
    #
    # @return [Boolean] returns a boolean
    #
    def self.is_valid_email?(email)
      email =~ REGEX_EMAIL
    end

    # Is the Domain a Valid Domain Name
    #
    # * Author:
    # * Date:
    # * Reviewed By:
    #
    # @return [Boolean] returns a boolean
    #
    def self.is_valid_domain?(domain_name)
      domain_name =~ REGEX_DOMAIN_NAME
    end

    # Is the url Valid
    #
    # * Author:
    # * Date:
    # * Reviewed By:
    #
    # @return [Boolean] returns a boolean
    #
    def self.is_valid_url?(url)
      return false if !is_string?(url)
      uri_value = URI.parse(url) rescue ""
      return false if uri_value.blank? || (URI::HTTPS != uri_value.class) ||
          !is_valid_domain?(uri_value.host)
      true
    end

  end
end
