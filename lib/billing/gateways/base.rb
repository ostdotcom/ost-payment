module Billing

  module Gateways

    class Base

      def validate_params(params, expected_params)
        final_params = {}
        missing_mandatory_params = []
        expected_params[:mandatory].each do |field|
          missing_mandatory_params << field unless params.key?(field)
        end

        return error_with_data(
            'mpm_1',
            'invalid_params',
            'invalid params',
            GlobalConstant::ErrorAction.default,
            {}
        ) if missing_mandatory_params.any?

        partially_required_params = expected_params[:partially_required][:fields]

        return error_with_data(
            'mpm_2',
            'invalid_params',
            'invalid params',
            GlobalConstant::ErrorAction.default,
            {}
        ) unless (params.keys - partially_required_params.keys).length <=
            (params.keys.length - expected_params[:partially_required][:min])

        valid_params = expected_params[:mandatory] + expected_params[:optional] +
            expected_params[:partially_required][:fields]

        valid_params.each do |field|
          final_params[field] = params[field]
        end

        success_with_data(final_params)

      end


    end

  end

end
