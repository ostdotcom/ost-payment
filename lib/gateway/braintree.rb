module Gateway

  class Braintree < Base

    # Initialize
    #
    # * Author:
    # * Date:
    # * Reviewed By:
    #
    def initialize(params)

      gateway_details = params[:gateway_details]
      @merchant_id = gateway_details[:merchant_id]
      @public_key = gateway_details[:public_key]
      @private_key = gateway_details[:private_key]
      @environment = gateway_details[:environment]

      initialize_braintree_obj

    end

    # initialize braintree obj
    #
    # * Author: Mayur
    # * Date: 31/05/2019
    # * Reviewed By
    #
    def initialize_braintree_obj
      @gateway = ::Braintree::Gateway.new(
          :environment => @environment,
          :merchant_id => @merchant_id,
          :public_key => @public_key,
          :private_key => @private_key
      )
    end

    #
    # generate_token
    #
    # * Author: Mayur
    # * Date: 31/05/2019
    # * Reviewed By
    #
    def generate_token(params)
      g_t_params = params[:customer_id].present? ? {customer_id: params[:customer_id]} : {}
      gateway_token = @gateway.client_token.generate(g_t_params)
      success_with_data({gateway_token: gateway_token})
    end

    #
    # create payment method
    #
    # * Author: Mayur
    # * Date: 31/05/2019
    # * Reviewed By
    #
    def create_payment_method(params)
      r = validate_params(params, {mandatory: [:customer_id, :nonce]})

      return r unless r.success?

      result = @gateway.payment_method.create(
          :customer_id => params[:customer_id],
          :payment_method_nonce => params[:nonce]
      )
      success_with_data({result: result})
    end

    #
    # update payment method
    #
    # * Author: Mayur
    # * Date: 31/05/2019
    # * Reviewed By
    #
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


    #
    # sale
    #
    # * Author: Mayur
    # * Date: 31/05/2019
    # * Reviewed By
    #
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

    # Create customer
    #
    # * Author: Mayur
    # * Date: 31/05/2019
    # * Reviewed By
    #
    def create_customer(params)
      r = validate_params(params, {optional: [:id, :first_name, :last_name, :comapny, :email, :phone, :fax, :website, :payment_method_nonce, :credit_card, :custom_fields]})
      return r unless r.success?
      result = @gateway.customer.create(params)
      success_with_data({result: result})
    end


    # Update customer
    #
    # * Author: Mayur
    # * Date: 31/05/2019
    # * Reviewed By
    #
    def update_customer(params)
      r = validate_params(params, {mandatory: [:customer_id],
                                    optional: [:id, :first_name, :last_name, :comapny, :email, :phone, :fax, :website, :payment_method_nonce, :credit_card, :custom_fields]})
      return r unless r.success?
      result = @gateway.customer.update(params)
      success_with_data({result: result})
    end

  end
end
