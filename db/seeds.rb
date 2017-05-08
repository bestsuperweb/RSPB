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