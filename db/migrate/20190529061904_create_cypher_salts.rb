class CreateCypherSalts < DbMigrationConnection

  def up
    run_migration_for_db(EstablishOstPaymentClientDbConnection.config_key) do

      create_table :cypher_salts do |t|

        t.column :entity_type, :string, null: false
        t.column :entity_id, :integer, limit: 8, null: false
        t.column :salt, :blob, null: false
        t.timestamps

      end
      add_index :cypher_salts, [:entity_type,:entity_id], unique: true, name: 'entity_type_entity_id'

    end
  end

  def down
    run_migration_for_db(EstablishOstPaymentClientDbConnection.config_key) do
      drop_table :cypher_salts
    end
  end


end


