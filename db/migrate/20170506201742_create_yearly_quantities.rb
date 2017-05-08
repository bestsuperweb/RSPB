class CreateYearlyQuantities < ActiveRecord::Migration[5.0]
  def change
    create_table :yearly_quantities do |t|
      t.string :yearly_quantity_label

      t.timestamps
    end
  end
end
