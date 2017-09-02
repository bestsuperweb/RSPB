class AddWebhookIdToWallets < ActiveRecord::Migration[5.0]
  def change
    add_column :wallets, :webhook_id, :integer
  end
end
