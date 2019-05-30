module Billing

  module Gateways

    class BraintreeGateway < Base

      def initialize(params)
        @merchant_id = params[:merchant_id]
        @public_key = params[:public_key]
        @private_key = params[:private_key]
        initialize_braintree_obj
      end

      def initialize_braintree_obj
        @gateway = Braintree::Gateway.new(
            :environment => :sandbox,
            :merchant_id => @merchant_id,
            :public_key => @public_key,
            :private_key => @private_key
        )
      end

      def generate_token(params)
        g_t_params = params[:customer_id].present? ? {customer_id: params[:customer_id]} : {}
        gateway_token = @gateway.client_token.generate(g_t_params)
        success_with_data({gateway_token: gateway_token})
      end

      def create_payment_method(params)
        r = validate_params(params, {mandatory: [:customer_id, :nonce]})

        return r unless r.success?

        result = @gateway.payment_method.create(
            :customer_id => params[:customer_id],
            :payment_method_nonce => params[:nonce]
        )
        success_with_data({result: result})
      end

      def update_payment_method(params)
        r = validate_params(params, {mandatory: [:payment_method_token],
                                     optional: [:billing_address]})
        return r unless r.success?
        result = @gateway.payment_method.update(
            params[:payment_method_token],
            :billing_address => {
                :street_address => params[:street_address],
                :extended_address => params[:extended_address],
                :locality => params[:locality],
                :region => params[:region],
                :postal_code => params[:postal_code],
                :options => {
                    :update_existing => true
                }
            }
        )
        success_with_data({result: result})
      end

      def sale(params)
        r = validate_params(params, {mandatory: [:amount],
                                     partially_required: {min: 1, fields:
                                         [:payment_method_nonce, :customer_id, :payment_method_token],
                                     optional: [:customer, :order_id, :billing, :shipping, :options,
                                                :merchant_account_id, :custom_fields]}
               })
        return r unless r.success?
        params = r.data
        result = @gateway.transaction.sale(
            params
        )
        success_with_data({result: result})

      end

      def create_customer(params)
        r = validate_params(params, {optional: [:id, :first_name, :last_name, :comapny, :email, :phone, :fax, :website, :payment_method_nonce,:credit_card, :custom_fields]})
        return r unless r.success?
        result = @gateway.customer.create(params)
        success_with_data({result: result})
      end


    end

  end

end
