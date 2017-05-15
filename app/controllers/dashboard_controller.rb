class DashboardController < ApplicationController
    
    include ShopifyApp::AppProxyVerification
    include AppProxyAuth
    require 'shopify_api'
    
  def index
    
   @user_id = login_to_shopify('verify_logged_in_user')
  
   if(@user_id)
        @customerorders = ShopifyAPI::Order.all(params: {id: @user_id, limit: 50, page: 1})
        render layout: true, content_type: 'application/liquid'
    else
      @error_msg ="Please don't try to override the url"
      render '404/index.html', layout: true, content_type: 'application/liquid' 
    end

  end

end
