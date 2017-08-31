# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

YearlyQuantity.create(yearly_quantity_label: 'Just a few; less than 100')
YearlyQuantity.create(yearly_quantity_label: 'Less than 1,000')
YearlyQuantity.create(yearly_quantity_label: '1,000 - 10,000')
YearlyQuantity.create(yearly_quantity_label: 'More than 10,000')
YearlyQuantity.create(yearly_quantity_label: 'Just one-off')

Turnaround.create(name: '6 Hours', handle: '6', multiplier: '3.00')
Turnaround.create(name: '12 Hours', handle: '12', multiplier: '1.75')
Turnaround.create(name: '24 Hours', handle: '24', multiplier: '1.00')
Turnaround.create(name: '48 Hours', handle: '48', multiplier: '0.93')
Turnaround.create(name: '96 Hours', handle: '96', multiplier: '0.85')
Turnaround.create(name: '96+ Hours', handle: '168', multiplier: '0.85')

VolumeDiscount.create(name: 'Small', handle: 's', multiplier: '1.20')
VolumeDiscount.create(name: 'Medium', handle: 'm', multiplier: '1.10')
VolumeDiscount.create(name: 'Large', handle: 'l', multiplier: '1.00')
VolumeDiscount.create(name: 'Extra large', handle: 'el', multiplier: '0.90')

ExchangeRate.create(usd: '1', gbp: '0.77011')

#Wallet.create(customer_id: '4281588171', transection_type: 'credit', currency: 'USD', subtotal: '4.50', tax: '0.09', total: '5.40', wallet_balance: '5.40', test: true)
