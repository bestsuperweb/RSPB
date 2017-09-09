class CreateProductVariants < ActiveRecord::Migration[5.0]
  def change
    create_table :product_variants do |t|
      t.references :product, foreign_key: true
      t.string :name
      t.string :handle
      t.decimal :variant_price, precision: 8, scale: 2
      t.boolean :published

      t.timestamps
    end
  end
end
