class Admin::PricingController < ApplicationController
    layout 'admin'
    #require 'pp'

    def index

        @product_variants = ProductVariant.includes(:product).all
        @turnarounds = Turnaround.all
        @volume_discounts = VolumeDiscount.all

        #render layout: true
    end

end
