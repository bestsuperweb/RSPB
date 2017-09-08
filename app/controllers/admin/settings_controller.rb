class Admin::SettingsController < ShopifyApp::AuthenticatedController
  layout 'admin'

  def index
    #@user_id = 4281588171
    #@quotations = Quotation.where(customer_id: @user_id)
    @single_column = "single_column"
    @exchange_rates = ExchangeRate.all
    @turnarounds = Turnaround.all
    @volume_discounts = VolumeDiscount.all
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
    redirect_to "/admin/settings"
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
    redirect_to "/admin/settings"
  end

end
