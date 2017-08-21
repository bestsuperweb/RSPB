class Turnaround < ApplicationRecord
    validates_uniqueness_of :name, :handle
    validates :multiplier, :format => { :with => /\A\d+(?:\.\d{0,2})?\z/ }, :numericality => {:greater_than => 0, :less_than => 10}
end
