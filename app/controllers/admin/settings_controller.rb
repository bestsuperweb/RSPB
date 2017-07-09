class Admin::SettingsController < ShopifyApp::AuthenticatedController
  layout 'admin'

  def index
    #@user_id = 4281588171
    #@quotations = Quotation.where(customer_id: @user_id)
    @single_column = "single_column"
    @exchange_rates = ExchangeRate.all
  end

end
