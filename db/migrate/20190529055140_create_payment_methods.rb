class CreatePaymentMethods < DbMigrationConnection

  def up
    run_migration_for_db(EstablishOstPaymentClientDbConnection.config_key) do

      create_table :payment_methods do |t|

        t.column :client_id, :integer, limit: 8, null: false
        t.column :customer_id, :integer, limit: 8, null: true
        t.column :gateway_type, :tinyint, limit: 2, null: false
        t.column :payment_method, :tinyint, limit: 2, null: false
        t.column :details, :text, null: true
        t.column :token, :string, limit: 8, null: true
        t.column :is_default, :boolean, limit: 8, null: true

        t.timestamps

        add_index :payment_methods, [:client_id, :customer_id, :is_default], unique: true, name: 'client_id_customer_id_is_default'
      end
    end
  end

  def down
    run_migration_for_db(EstablishOstPaymentClientDbConnection.config_key) do
      drop_table :payment_methods
    end
  end


end



