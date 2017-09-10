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

VolumeDiscount.create(name: 'Regular', handle: 'r', multiplier: '1')
VolumeDiscount.create(name: 'Large', handle: 'l', multiplier: '0.90')
VolumeDiscount.create(name: 'Extra large', handle: 'el', multiplier: '0.82')

ExchangeRate.create(usd: '1', gbp: '0.77011')

if product = Product.create(title: 'Clipping path', handle: 'clipping-path')
    ProductVariant.create(product_id: product.id, name: 'Category 1', handle: 'c1', variant_price: '0.49')
    ProductVariant.create(product_id: product.id, name: 'Category 2', handle: 'c2', variant_price: '0.89')
    ProductVariant.create(product_id: product.id, name: 'Category 3', handle: 'c3', variant_price: '1.59')
    ProductVariant.create(product_id: product.id, name: 'Category 4', handle: 'c4', variant_price: '3.99')
    ProductVariant.create(product_id: product.id, name: 'Category 5', handle: 'c5', variant_price: '7.99')
    ProductVariant.create(product_id: product.id, name: 'Category 6', handle: 'c6', variant_price: '11.99')
end
if product = Product.create(title: 'Shadow effect', handle: 'shadow-effect')
    ProductVariant.create(product_id: product.id, name: 'Drop shadow category 1', handle: 'dsc1', variant_price: '0.25')
    ProductVariant.create(product_id: product.id, name: 'Drop shadow category 2', handle: 'dsc2', variant_price: '0.25')
    ProductVariant.create(product_id: product.id, name: 'Drop shadow category 3', handle: 'dsc3', variant_price: '0.25')
    ProductVariant.create(product_id: product.id, name: 'Existing shadow', handle: 'esc1', variant_price: '0.79')
    ProductVariant.create(product_id: product.id, name: 'Natural shadow category 1', handle: 'nsc1', variant_price: '0.79')
    ProductVariant.create(product_id: product.id, name: 'Natural shadow category 2', handle: 'nsc2', variant_price: '1.49')
    ProductVariant.create(product_id: product.id, name: 'Natural shadow category 3', handle: 'nsc3', variant_price: '3.49')
    ProductVariant.create(product_id: product.id, name: 'Floating shadow', handle: 'fsc1', variant_price: '0.25')
    ProductVariant.create(product_id: product.id, name: 'Mirror effect category 1', handle: 'mec1', variant_price: '0.49')
    ProductVariant.create(product_id: product.id, name: 'Mirror effect category 2', handle: 'mec2', variant_price: '1.49')
    ProductVariant.create(product_id: product.id, name: 'Mirror effect category 3', handle: 'mec3', variant_price: '3.49')
end

# params = { product: {
#   title: 'Clipping path', handle: 'clipping-path', product_variants_attributes: [
#     { name: 'Category 1' },
#     { handle: 'c1' },
#     { variant_price: '0.49' }
#   ]
# }}
# Product.create(params[:product])