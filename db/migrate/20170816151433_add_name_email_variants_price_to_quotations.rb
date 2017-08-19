class AddNameEmailVariantsPriceToQuotations < ActiveRecord::Migration[5.0]
  def change
    add_column :quotations, :customer_name, :string
    add_column :quotations, :customer_email, :string
    add_column :quotations, :product_variants, :text
    add_column :quotations, :total_price, :decimal, precision: 8, scale: 2
  end
end
