class CreateOstPaymentTokens < DbMigrationConnection

  def up
    run_migration_for_db(EstablishOstPaymentClientDbConnection.config_key) do

      create_table :ost_payment_tokens do |t|
        t.column :uuid, :string, limit: 20, null: false
        t.column :client_id, :integer, limit: 8, null: false
        t.column :customer_id, :integer, limit: 8, null: true
        t.column :creation_timestamp, :integer, limit: 8, null: false
        t.column :expiry_interval, :integer, limit: 8, null: false
        t.column :token, :string, limit: 8, null: false
        t.column :status, :tinyint, limit: 1, null: false

        t.timestamps

        add_index :ost_payment_tokens, [:token], unique: true, name: 'token'

      end
    end
  end

  def down
    run_migration_for_db(EstablishOstPaymentClientDbConnection.config_key) do
      drop_table :ost_payment_tokens
    end
  end


end


