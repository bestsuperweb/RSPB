module Admin::CustomersHelper

  def customer_tab_url(tab)
    customer_params = ""
    if(params.has_key?(:id) && params.has_key?(:shop))
      customer_params = "?id="+params[:id]+"&shop="+params[:shop]
    end

    if tab == 'account'
      return admin_customer_account_path+"/"+customer_params
    elsif tab == 'wallet'
      return admin_customer_wallet_path+"/"+customer_params
    elsif tab == 'billing'
      return admin_customer_billing_path+"/"+customer_params
    elsif tab == 'templates'
      return admin_customer_templates_path+"/"+customer_params
    end
  end

end
