class CreateQuotations < ActiveRecord::Migration[5.0]
  def change
    create_table :quotations do |t|
      t.integer :customer_id
      t.text :message
      t.integer :quantity
      t.references :yearly_quantity, foreign_key: true
      t.boolean :resize_image
      t.string :image_width
      t.string :image_height
      t.boolean :set_margin

      t.timestamps
    end
    #add_index :quotations, :customer_id
  end
end
