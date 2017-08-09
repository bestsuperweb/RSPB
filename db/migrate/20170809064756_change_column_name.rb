class ChangeColumnName < ActiveRecord::Migration[5.0]
  def change
    rename_column :quotations, :additional_commen, :additional_comment
  end
end
