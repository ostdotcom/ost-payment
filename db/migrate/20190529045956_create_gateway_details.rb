class CreateGatewayDetails < DbMigrationConnection
  def up
    run_migration_for_db(EstablishOstPaymentClientDbConnection.config_key) do

      create_table :gateway_details do |t|
        t.column :client_id, :integer, limit: 8, null: false
        t.column :gateway_type, :tinyint, limit: 2, null: false
        t.column :status, :tinyint, limit: 1, null: false
        t.column :details, :text, null: false

        t.timestamps


      end
      add_index :gateway_details, [:client_id, :gateway_type, :status], unique: false,
                name: 'client_id_gateway_type_status'

    end

  end

  def down
    run_migration_for_db(EstablishOstPaymentClientDbConnection.config_key) do
      drop_table :gateway_details
    end
  end




end
