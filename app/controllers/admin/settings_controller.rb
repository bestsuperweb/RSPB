class Admin::SettingsController < ShopifyApp::AuthenticatedController
    layout 'admin'

    def index
        #@user_id = 4281588171
        #@quotations = Quotation.where(customer_id: @user_id)
        @single_column = "single_column"
        @turnarounds = Turnaround.all
        @volume_discounts = VolumeDiscount.all
        @products = Product.all
        @product_variants = ProductVariant.where(product_id: params[:product_id])
    end


    def turnaround_multipliers
        i = 0
        params[:id].each do |key|
            q = Turnaround.find(params[:id][i])
            if q
                q.multiplier = params[:multiplier][i]
                q.available_at_price = params[:available_at_price][i]
                q.save
            end
            i += 1
        end
        flash[:notice] = "Turnaround multipliers saved successfully."
        redirect_to admin_settings_path
    end


    def volume_discounts
        params[:volume_discounts].each do |key,value|
          volume_discount = VolumeDiscount.find(key)
            if volume_discount
                volume_discount.multiplier = value
                volume_discount.save
            end
        end
        flash[:notice] = "Volume Discounts saved successfully."
        redirect_to admin_settings_path
    end


    def product_variants
        params[:product_variants].each do |key,value|
          product_variant = ProductVariant.find(key)
            if product_variant
                product_variant.variant_price = value
                product_variant.save
            end
        end
        flash[:notice] = "Price saved successfully."
        redirect_to admin_settings_path(product_id: params[:product_variant][:product_id])
    end

end
