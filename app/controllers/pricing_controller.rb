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
        "Drop shadow" => 0.25,
        "Existing shadow" => 0.79,
        "Natural shadow category-1" => 0.75,
        "Natural shadow category-2" => 1.49,
        "Natural shadow category-3" => 3.99,
        "Floating shadow" => 0.25,
        "Mirror effect category-1" => 0.49,
        "Mirror effect category-2" => 1.49,
        "Mirror effect category-3" => 3.99,
      }
    }

    @turnaround = {
     "6 Hours" => 2.5,
      "12 Hours" => 1.75,
      "24 Hours" => 1.0,
      "48 Hours" => 0.93,
      "96 Hours" => 0.85,
      "96+ Hours" => 0.85,
    }

    @volume = {
     "Small" => 1.20,
      "Medium" => 1.10,
      "Large" => 1.00,
      "Extra large" => 0.90,
    }

  end
  
  
   def need
    
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
        "Drop shadow" => 0.25,
        "Existing shadow" => 0.79,
        "Natural shadow (Category 1)" => 0.75,
        "Natural shadow (Category 2)" => 1.49,
        "Natural shadow (Category 3)" => 3.99,
        "Floating shadow" => 0.25,
        "Mirror effect (Category 1)" => 0.49,
        "Mirror effect (Category 2)" => 1.49,
        "Mirror effect (Category 3)" => 3.99,
      }
    }

    @turnaround = {
     "6 Hours" => 3.0,
      "12 Hours" => 1.75,
      "24 Hours" => 1.0,
      "48 Hours" => 0.93,
      "96 Hours" => 0.85,
      "96+ Hours" => 0.85,
    }

    @volume = {
     "Small" => 1.20,
     "Medium" => 1.10,
     "Large" => 1.00,
     "Extra large" => 0.90,
    }

    render layout: true, content_type: 'application/liquid'
  end
end
