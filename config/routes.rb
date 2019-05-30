Rails.application.routes.draw do

  scope '/webapps/gateway', controller: 'webapps/gateway' do
    get ':gateway_type/generate-token' => :generate_gateway_token
    get ':gateway_type/save-nonce' => :save_nonce


  end


  match '/', to: 'application#not_found', via: :all
  match '*permalink', to: 'application#not_found', via: :all

end