class RemovesetMarginFromQuotation < ActiveRecord::Migration[5.0]
  def change
    remove_column :quotations, :set_margin
  end
end
