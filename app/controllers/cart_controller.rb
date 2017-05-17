class CartController < ApplicationController
    include ShopifyApp::AppProxyVerification

  def index
    render layout: true, content_type: 'application/liquid'
  end

end
