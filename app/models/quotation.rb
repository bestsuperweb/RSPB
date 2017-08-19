class Quotation < ApplicationRecord
    has_many :templates, dependent: :destroy
end
