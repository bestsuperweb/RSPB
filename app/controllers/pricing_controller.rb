class PricingController < ApplicationController
  def index
    
    @services = {
      "Clipping path" => {
        "Complexity-1" => 0.39,
        "Complexity-2" => 0.69,
        "Complexity-3" => 0.99,
        "Complexity-4" => 1.29,
        "Complexity-5" => 1.89,
        "Complexity-6" => 2.99,
        "Complexity-7" => 4.49,
        "Complexity-8" => 5.99,
        "Complexity-9" => 7.99,
        "Complexity-10" => 9.99,
      },
      "Shadow effect" => {
        "Drop shadow" => 0.49,
        "Natural shadow" => 0.75,
        "Existing shadow" => 0.75,
        "Mirror effect" => 0.99,
      },
      "Retouching" => {
        "Simple" => 0.49,
        "Medium" => 0.99,
        "Complex" => 1.99,
        "Super complex" => 2.99,
      }
    }
    
    @turnaround = {
      "6 Hours" => 3.0,
      "12 Hours" => 1.75,
      "24 Hours" => 1.0,
      "48 Hours" => 0.93,
      "96 Hours" => 0.85,
    }
    
    @volume = {
      "Small" => 1.2,
      "Medium" => 1.10,
      "Large" => 1.00,
      "Extra large" => 0.90,
    }
    
=begin    
    services.each do |service, options|
      options.each do |option, price|
        @pricing_array = [
          'service' => service, 
          'price' => price
        ]
      end
    end
    #puts pricing_array.inspect
=end

=begin
    data_array = Hash.new
    
    services.each do |service, options|
      options.each do |option, price|
        turnaround.each do |time, t_m|
          volume.each do |quantity, v_m|
            price = price*t_m/100 + price*v_m/100
            data_array['service'] = service
            data_array['price'] = price
          end
        end
      end
    end

    @data = data_array
=end

  end
end
