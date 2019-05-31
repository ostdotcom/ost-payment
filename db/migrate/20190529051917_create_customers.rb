class CreateCustomers < DbMigrationConnection
  def up
    run_migration_for_db(EstablishOstPaymentClientDbConnection.config_key) do

      create_table :customers do |t|
        t.column :client_id, :integer, limit: 8, null: false
        t.column :status, :tinyint, limit: 1, null: false
        t.column :details, :text, null: true
        t.timestamps
      end
      add_index :customers, [:client_id], unique: false, name: 'client_id'
    end
  end

  def down
    run_migration_for_db(EstablishOstPaymentClientDbConnection.config_key) do
      drop_table :customers
    end
  end




end
