class Admin::CustomersController < ShopifyApp::AuthenticatedController
  layout 'admin'

  def account
    check_customer_id_present
    @tab = "account"
    @order_emails   = ShopifyAPI::Metafield.find(:first,:params=>{  :resource => "customers",
                                                                    :resource_id => params[:id],
                                                                    :namespace => "addtional_emails",
                                                                    :key => "order_notification_emails" })
    @billing_emails = ShopifyAPI::Metafield.find(:first,:params=>{  :resource => "customers",
                                                                    :resource_id => params[:id],
                                                                    :namespace => "addtional_emails",
                                                                    :key => "billing_notification_emails" })
    @website_url    = ShopifyAPI::Metafield.find(:first,:params=>{  :resource => "customers",
                                                                    :resource_id => params[:id],
                                                                    :namespace => "company_info",
                                                                    :key => "website_url" })
    @vat_number     = ShopifyAPI::Metafield.find(:first,:params=>{  :resource => "customers",
                                                                    :resource_id => params[:id],
                                                                    :namespace => "company_info",
                                                                    :key => "vat_number" })

    @order_emails   = @order_emails.value unless @order_emails.nil?
    @billing_emails = @billing_emails.value unless @billing_emails.nil?
    @website_url    = @website_url.value unless @website_url.nil?
    @vat_number     = @vat_number.value unless @vat_number.nil?

    @order_emails   = "," if @order_emails.nil?
    @billing_emails = "," if @billing_emails.nil?
    @website_url    = "" if @website_url.nil?
    @vat_number     = "" if @vat_number.nil?

    #puts @billing_emails
    #render :nothing => true
    render "index"
  end

  def wallet
    check_customer_id_present
    @wallets = Wallet.where(customer_id: params[:id]).order(updated_at: :desc)
    @tab = "wallet"
    render "index"
  end

  def billing
    check_customer_id_present
    @tab = "billing"
    render "index"
  end

  def templates
    check_customer_id_present
    @tab = "templates"
    render "index"
  end

  def account_update

    @tab = "account"
    flash[:notice] = "Account successfully saved."
    redirect_to admin_customer_account_path(id: params[:customer_id], shop: params[:shop])
  end

  private
  def check_customer_id_present
    unless params.has_key?(:id)
      raise ActionController::RoutingError.new('Not Found')
    end
  end

end
