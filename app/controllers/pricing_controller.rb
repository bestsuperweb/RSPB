class PricingController < ApplicationController
  def index
    
    @services = {
      "Clipping path" => {
        "Complexity-1" => 0.39,
        "Complexity-2" => 0.69,
        "Complexity-3" => 0.99,
        "Complexity-4" => 1.39,
        "Complexity-5" => 1.99,
        "Complexity-6" => 2.99,
        "Complexity-7" => 3.99,
        "Complexity-8" => 4.99,
        "Complexity-9" => 5.99,
        "Complexity-10" => 6.99,
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
      "6 Hours" => 200,
      "12 Hours" => 150,
      "24 Hours" => 100,
      "48 Hours" => -10,
      "96 Hours" => -20,
    }
    
    @volume = {
      "Small" => 120,
      "Medium" => 100,
      "Large" => -10,
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
