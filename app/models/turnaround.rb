class Turnaround < ApplicationRecord
    validates_uniqueness_of :name, :handle
end
