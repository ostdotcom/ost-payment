
class CreateGatewayCustomerAssociations < DbMigrationConnection
  def up
    run_migration_for_db(EstablishOstPaymentClientDbConnection.config_key) do

      create_table :gateway_customer_associations do |t|

        t.column :customer_id, :integer, limit: 8, null: false
        t.column :gateway_type, :tinyint, limit: 2, null: false
        t.column :gateway_customer_id, :integer, limit: 8, null: false
        t.column :status, :tinyint, limit: 2, null: false

        t.timestamps

      end

      add_index :gateway_customer_associations, [:customer_id, :gateway_type], unique: true, name: 'customer_id_gateway_type'
    end
  end

  def down
    run_migration_for_db(EstablishOstPaymentClientDbConnection.config_key) do
      drop_table :gateway_customer_associations
    end
  end

end


