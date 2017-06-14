class CreateExchangeRates < ActiveRecord::Migration[5.0]
  def change
    create_table :exchange_rates do |t|
      t.decimal :usd
      t.decimal :gbp

      t.timestamps
    end
  end
end
