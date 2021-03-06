class ServicesBase

  include Util::ResultHelper

  attr_reader :params

  # Initialize ServiceBase instance
  #
  # * Author: Kedar
  # * Date: 09/10/2017
  # * Reviewed By: Sunil Khedar
  #
  def initialize(service_params={})
    service_klass = self.class.to_s
    service_params_list = ServicesBase.get_service_params(service_klass)
    service_params_list.deep_symbolize_keys!

    # passing only the mandatory and optional params to a service
    permitted_params_list = ((service_params_list[:mandatory] || []) + (service_params_list[:optional] || [])) || []

    permitted_params = {}

    permitted_params_list.each do |pp|
      permitted_params[pp] = service_params[pp.to_sym]
    end

    @params = HashWithIndifferentAccess.new(permitted_params)
  end





  # Method to get service params from yml file
  #
  # * Author: Kedar
  # * Date: 09/10/2017
  # * Reviewed By: Sunil Khedar
  #
  def self.get_service_params(service_class)
    # Load mandatory params yml only once
    @mandatory_params ||= YAML.load_file(open(Rails.root.to_s + '/app/services/service_params.yml'), safe: true)
    @mandatory_params[service_class.to_s]
  end

  # Current Time
  #
  # * Author: Sunil Khedar
  # * Date: 19/10/2017
  # * Reviewed By: Kedar
  #
  def current_time
    @c_t ||= Time.now
  end

  # Current Time Stamp
  #
  # * Author: Sunil Khedar
  # * Date: 19/10/2017
  # * Reviewed By: Kedar
  #
  def current_timestamp
    @c_tstmp ||= current_time.to_i
  end

  private

  # Method to validate presence of params
  #
  # * Author: Kedar
  # * Date: 09/10/2017
  # * Reviewed By: Sunil Khedar
  #
  # @return [Result::Base]
  #
  def validate
    # perform presence related validations here
    # result object is returned
    service_params_list = ServicesBase.get_service_params(self.class.to_s)
    missing_mandatory_params = []
    service_params_list[:mandatory].each do |mandatory_param|
      missing_mandatory_params << "missing_#{mandatory_param}" if @params[mandatory_param].to_s.blank?
    end if service_params_list[:mandatory].present?

    return error_with_identifier('mandatory_params_missing',
                                 'sb_1',
                                 missing_mandatory_params
    ) if missing_mandatory_params.any?

    success
  end

end