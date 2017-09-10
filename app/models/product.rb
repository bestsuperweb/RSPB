class Product < ApplicationRecord
    has_many :product_variants, dependent: :destroy
    accepts_nested_attributes_for :product_variants
    validates_uniqueness_of :handle
    validates :title, presence: true
    validates :handle, presence: true
end
