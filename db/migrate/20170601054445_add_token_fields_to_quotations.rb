class AddTokenFieldsToQuotations < ActiveRecord::Migration[5.0]
  def change
    add_column :quotations, :token, :string, {:default=>" "}
  end
end
