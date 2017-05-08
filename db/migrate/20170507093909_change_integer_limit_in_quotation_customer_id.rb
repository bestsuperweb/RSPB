class ChangeIntegerLimitInQuotationCustomerId < ActiveRecord::Migration[5.0]
  def change
    change_column :quotations, :customer_id, :integer, limit: 8
  end
end
