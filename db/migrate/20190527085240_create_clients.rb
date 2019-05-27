class CreateClients < DbMigrationConnection

  def up

    run_migration_for_db(EstablishOstPaymentClientDbConnection.config_key) do

      create_table :clients do |t|
        t.column :name, :string, null: false
        t.column :status, :tinyint, limit: 1, null: false
        t.column :salt, :blob, null: false
        t.timestamps
      end

    end

  end

  def down
    run_migration_for_db(EstablishOstPaymentClientDbConnection.config_key) do
      drop_table :clients
    end
  end

end