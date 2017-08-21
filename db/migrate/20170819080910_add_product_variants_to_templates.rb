class AddProductVariantsToTemplates < ActiveRecord::Migration[5.0]
  def change
    add_column :templates, :product_variants, :text
  end
end
