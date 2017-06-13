class ChangeQuotationStatusDefault < ActiveRecord::Migration[5.0]
  def change
     change_column(:quotations, :status, :string, {:default=>"new"})
  end
end
