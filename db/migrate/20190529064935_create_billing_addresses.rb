class CreateBillingAddresses < DbMigrationConnection

  def up
    run_migration_for_db(EstablishOstPaymentClientDbConnection.config_key) do

      create_table :billing_addresses do |t|

        t.column :payment_method_id, :integer, limit: 8, null: false
        t.column :details, :text, null: false
        t.timestamps

      end
      add_index :billing_addresses, [:payment_method_id], unique: true, name: 'payment_method_id'

    end
  end

  def down
    run_migration_for_db(EstablishOstPaymentClientDbConnection.config_key) do
      drop_table :billing_addresses
    end
  end


end


