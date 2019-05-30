class CreateGatewayTokens < DbMigrationConnection

  def up
    run_migration_for_db(EstablishOstPaymentClientDbConnection.config_key) do

      create_table :gateway_tokens do |t|

        t.column :ost_payment_token_id, :integer, limit: 8, null: false
        t.column :gateway_type, :tinyint, limit: 2, null: false
        t.column :gateway_customer_id, :integer, limit: 8, null: true
        t.column :gateway_token, :string, limit: 8, null: false

        t.timestamps
      end

      add_index :gateway_tokens, [:ost_payment_token_id, :gateway_type], unique: true, name: 'ost_payment_token_id_gateway_type'

    end
  end

  def down
    run_migration_for_db(EstablishOstPaymentClientDbConnection.config_key) do
      drop_table :gateway_tokens
    end
  end


end


