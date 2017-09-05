class AddDraftOrderIdToWallets < ActiveRecord::Migration[5.0]
  def change
    add_column :wallets, :draft_order_id, :integer, limit: 8
  end
end
