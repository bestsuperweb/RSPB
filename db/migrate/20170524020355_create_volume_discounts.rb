class CreateVolumeDiscounts < ActiveRecord::Migration[5.0]
  def change
    create_table :volume_discounts do |t|
      t.string :name
      t.string :handle
      t.decimal :multiplier

      t.timestamps
    end
    add_index :volume_discounts, :name, unique: true
    add_index :volume_discounts, :handle, unique: true
  end
end
