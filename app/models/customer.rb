class Customer
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  
  attr_accessor :first_name, :last_name, :email
  
    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :email, presence: true
    
#   validates_presence_of :first_name
#   validates_presence_of :last_name
#   validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def persisted?
    false
  end
end