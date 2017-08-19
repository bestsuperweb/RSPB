class IncreaseIntegerLimits < ActiveRecord::Migration[5.0]
  def change
    change_column :templates, :customer_id, :integer, limit: 8
    change_column :templates, :order_id, :integer, limit: 8
  end
end
