class Quotation < ApplicationRecord
    belongs_to :yearly_quantity
    validates :message, :quantity, :yearly_quantity_id,  presence: true
    validates_inclusion_of :resize_image, :in => [true, false]
    validates :quantity, numericality: { only_integer: true }
    validate :any_present?
    #validates_presence_of :image_width, :message => " Or Image height is required",  :if => :error_required_image_width?
   

    def any_present?
        if resize_image == false || resize_image.nil?
            false
        else
          if %w(image_height image_width).all?{|attr| self[attr].blank?}
            errors.add :base, "You should input at-least one field of resizing \"Height\" or \"Width\" "
          end
        end
    end
    
    
    def error_required_image_width?
       
       image_height_new = image_height.to_i == 0 ? 0 : image_height.to_i
       if resize_image == false || resize_image.nil?
            false
        else
            if resize_image == true && image_height_new > 0
            false
          else
            puts "height less than 0"
            return true
          end
        
        end
    end
    
end
