class AddMoreFieldsToQuotations < ActiveRecord::Migration[5.0]
  def change
    add_column :quotations, :product_variant_ids, :string
    add_column :quotations, :message_for_production, :text
    add_column :quotations, :status, :string
    add_column :quotations, :created_by_user_id, :integer, limit: 8
    add_column :quotations, :modified_by_user_id, :integer, limit: 8
  end
end