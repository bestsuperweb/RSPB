class Wallet < ApplicationRecord
    validates :customer_id, presence: true
    validates :transection_type, inclusion: { in: %w(credit debit), message: "%{value} is not a valid transection type" }, presence: true
    validates :currency, inclusion: { in: %w(USD GBP), message: "%{value} is not a valid currency" }, presence: true
    validates :subtotal, :format => { :with => /\A\d+(?:\.\d{0,2})?\z/ }, :numericality => {:less_than => 100000}
    validates :tax, :format => { :with => /\A\d+(?:\.\d{0,2})?\z/ }, :numericality => {:less_than => 100000}
    validates :total, :format => { :with => /\A\d+(?:\.\d{0,2})?\z/ }, :numericality => {:less_than => 100000}
    validates :wallet_balance, :format => { :with => /\A\d+(?:\.\d{0,2})?\z/ }, :numericality => {:greater_than_or_equal_to => 0, :less_than => 100000}

end
