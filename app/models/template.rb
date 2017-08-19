class Template < ApplicationRecord
  belongs_to :quotation
  validates :quotation_id, numericality: { only_integer: true }
  validates :template_name, presence: true
  validates :customer_id, presence: true, numericality: { only_integer: true }
end
