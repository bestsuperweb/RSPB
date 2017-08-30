class CreateWallets < ActiveRecord::Migration[5.0]
  def change
    create_table :wallets do |t|
      t.integer :customer_id, limit: 8
      t.integer :order_id, limit: 8
      t.integer :refund_id, limit: 8
      t.string :transection_type
      t.string :payment_method
      t.string :currency
      t.decimal :subtotal, precision: 8, scale: 2
      t.decimal :tax, precision: 8, scale: 2
      t.decimal :total, precision: 8, scale: 2
      t.decimal :wallet_balance, precision: 8, scale: 2
      t.boolean :test, default: false
      t.boolean :cancelled, default: false
      t.text :note
      t.integer :created_by_user_id, limit: 8
      t.integer :modified_by_user_id, limit: 8

      t.timestamps
    end
  end
end
