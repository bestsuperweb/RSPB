class CreateTemplates < ActiveRecord::Migration[5.0]
  def change
    create_table :templates do |t|
      t.integer :customer_id
      t.references :template, foreign_key: true
      t.integer :order_id
      t.string :template_name
      t.text :message
      t.string :product_variant_ids
      t.string :return_file_format
      t.boolean :set_margin, default: false
      t.boolean :resize_image, default: false
      t.integer :image_width
      t.integer :image_height
      t.text :message_for_production
      t.text :additional_comment
      t.integer :times_used
      t.datetime :last_used_at
      t.boolean :disabled, default: false

      t.timestamps
    end
  end
end
