class CreateTransactions < DbMigrationConnection

  def up
    run_migration_for_db(EstablishOstPaymentClientDbConnection.config_key) do

      create_table :transactions do |t|

        t.column :client_id, :integer, limit: 8, null: false
        t.column :customer_id, :integer, limit: 8, null: true
        t.column :gateway_transaction_id, :integer, limit: 8, null: false
        t.column :payment_method_id, :integer, limit: 8, null: false
        t.column :transaction_time, :integer, limit: 8, null: false
        t.column :transaction_info, :text, null: true
        t.column :transaction_status, :tinyint, limit: 2, null: false

        t.timestamps

      end
      add_index :transactions, [:client_id, :customer_id, :payment_method_id], unique: true, name: 'client_id_customer_id_payment_method_id'
    end
  end

  def down
    run_migration_for_db(EstablishOstPaymentClientDbConnection.config_key) do
      drop_table :transactions
    end
  end


end



