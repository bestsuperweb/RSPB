class AddSetmerginreturnfileformatToQuotations < ActiveRecord::Migration[5.0]
  def change
    add_column :quotations, :set_margin, :boolean
    add_column :quotations, :return_file_format, :string
  end
end
