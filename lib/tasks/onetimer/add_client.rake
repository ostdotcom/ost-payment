namespace :onetimer do

  params = {
      "client_name" => "OST PLATFORM DUMMY"
  }

  # params = params.to_json
  # rake RAILS_ENV=development onetimer:add_client params="{\"client_name\":\"OST PLATFORM DUMMY\"}"

  task :add_client => :environment do
    params = JSON.parse(ENV['params'])

    puts "::Started account setup::"

    puts "\tValidation started"
    fail 'client name cannot be blank' if params["client_name"].blank?
    puts "\tValidation passed"


    #get cmk key and text
    kms_login_client = Aws::Kms.new('saas', 'saas')
    resp = kms_login_client.generate_data_key
    return resp unless resp.success?

    salt_e = resp.data[:ciphertext_blob]
    salt_d = resp.data[:plaintext]

    client = Client.create(name: params["client_name"], status: GlobalConstant::Client.active_status,
                           salt: salt_e)
    client_id = client.id
    client_api_secret_d = SecureRandom.hex(16)

    r = LocalCipher.new(salt_d).encrypt(client_api_secret_d)
    return r unless r.success?

    api_secret_e = r.data[:ciphertext_blob]
    api_key = SecureRandom.hex(16)

    ClientApiDetail.create!({
                                client_id: client_id,
                                api_key: api_key,
                                api_secret: api_secret_e,
                                status: GlobalConstant::ClientApiDetail.active_status

                            })

    g_details = {
        merchant_id: "bfjnzfmjnp447nk7",
        public_key: "4mx9s3tpjdy78pw5",
        private_key: "d0a75f3c55ec37939524d8bbebf4d66f"
    }

    GatewayDetail.create({client_id: client_id,
                          gateway_type: GlobalConstant::GatewayType.braintree_gateway_type,
                          status: GlobalConstant::GatewayDetail.active_status,
                          details: g_details})
    puts "Client Setup complete"

  end
end
