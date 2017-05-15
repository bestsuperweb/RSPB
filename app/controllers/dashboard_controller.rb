class DashboardController < ApplicationController
    include ShopifyApp::AppProxyVerification

    include AppProxyAuth

  def index

    @user_id = login_to_shopify('verify_logged_in_user')

    @customerorders = ShopifyAPI::Order.all(params: {id: @user_id, limit: 50, page: 1})


   render layout: true, content_type: 'application/liquid'
  end



end
