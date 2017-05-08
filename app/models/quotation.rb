class Quotation < ApplicationRecord
    belongs_to :yearly_quantity
    validates :message, :quantity, :yearly_quantity_id, presence: true
    validates_inclusion_of :resize_image, :in => [true, false]
    validates :quantity, numericality: { only_integer: true }
end
