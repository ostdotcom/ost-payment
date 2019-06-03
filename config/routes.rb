Rails.application.routes.draw do

  scope '/webapps/v0/gateway', controller: 'webapps/gateway' do
    get ':gateway_type/generate-token' => :generate_gateway_token, via: :POST
    get ':gateway_type/save-nonce' => :save_nonce, via: :POST
  end


  scope '/api/v0', controller: 'rest_api/v0/ost_payment_controller' do
    post '/generate-token' => :generate_token
    post '/sale' => :sale
  end

  scope '/api/v0/customer', controller: 'rest_api/v0/customer_controller' do
    post '/' => :create_customer
    post '/:id' => :update_customer
  end

  match '/', to: 'application#not_found', via: :all
  match '*permalink', to: 'application#not_found', via: :all

end