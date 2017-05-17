class YearlyQuantity < ApplicationRecord
    has_many :quotations
    validates_uniqueness_of :yearly_quantity_label
end
