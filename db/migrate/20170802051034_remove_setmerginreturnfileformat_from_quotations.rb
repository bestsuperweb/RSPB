class RemoveSetmerginreturnfileformatFromQuotations < ActiveRecord::Migration[5.0]
  def change
      remove_column :quotations, :return_file_format
      remove_column :quotations, :set_margin
  end
end
