class AddAvailableatpriceToTurnarounds < ActiveRecord::Migration[5.0]
  def change
    add_column :turnarounds, :available_at_price, :integer
  end
end
