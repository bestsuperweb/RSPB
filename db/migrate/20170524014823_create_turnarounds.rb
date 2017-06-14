class CreateTurnarounds < ActiveRecord::Migration[5.0]
  def change
    create_table :turnarounds do |t|
      t.string :name
      t.string :handle
      t.decimal :multiplier

      t.timestamps
    end
    add_index :turnarounds, :name, unique: true
    add_index :turnarounds, :handle, unique: true
  end
end
