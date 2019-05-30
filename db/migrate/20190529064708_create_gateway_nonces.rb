class CreateGatewayNonces < DbMigrationConnection

  def up
    run_migration_for_db(EstablishOstPaymentClientDbConnection.config_key) do

      create_table :gateway_nonces do |t|
        t.column :uuid, :string, limit: 20, null: false
        t.column :ost_payment_token_id, :integer, limit: 8, null: false
        t.column :nonce, :string, limit: 32, null: true
        t.column :payload, :text, null: true
        t.column :gateway_type, :tinyint, limit: 2, null: false
        t.column :status, :tinyint, limit: 1, null: false
        t.timestamps


      end
      add_index :gateway_nonces, [:ost_payment_token_id, :gateway_type, :nonce], unique: true, name: 'ost_payment_token_id_gateway_type_nonce'

    end
  end

  def down
    run_migration_for_db(EstablishOstPaymentClientDbConnection.config_key) do
      drop_table :gateway_nonces
    end
  end

end

