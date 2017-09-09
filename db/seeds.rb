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

Turnaround.create(name: '6 Hours', handle: '6', multiplier: '3.00', available_at_price: '50')
Turnaround.create(name: '12 Hours', handle: '12', multiplier: '1.75', available_at_price: '100')
Turnaround.create(name: '24 Hours', handle: '24', multiplier: '1.00', available_at_price: '200')
Turnaround.create(name: '48 Hours', handle: '48', multiplier: '0.93', available_at_price: '400')
Turnaround.create(name: '96 Hours', handle: '96', multiplier: '0.85', available_at_price: '800')
Turnaround.create(name: '96+ Hours', handle: '168', multiplier: '0.85', available_at_price: '1400')

VolumeDiscount.create(name: 'Regular (Default)', handle: 'r', multiplier: '1')
VolumeDiscount.create(name: 'Large', handle: 'l', multiplier: '0.90')
VolumeDiscount.create(name: 'Extra large', handle: 'el', multiplier: '0.82')

ExchangeRate.create(usd: '1', gbp: '0.77011')