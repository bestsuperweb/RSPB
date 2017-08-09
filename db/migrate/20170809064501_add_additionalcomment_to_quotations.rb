class AddAdditionalcommentToQuotations < ActiveRecord::Migration[5.0]
  def change
    add_column :quotations, :additional_commen, :text
  end
end
