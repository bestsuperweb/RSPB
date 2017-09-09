class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string :title
      t.string :handle
      t.boolean :published, default: true

      t.timestamps
    end
  end
end
