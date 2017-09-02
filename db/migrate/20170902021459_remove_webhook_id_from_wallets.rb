class RemoveWebhookIdFromWallets < ActiveRecord::Migration[5.0]
  def change
    remove_column :wallets, :webhook_id, :integer
  end
end
