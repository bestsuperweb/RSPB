class AppProxyController < ApplicationController
    include ShopifyApp::AppProxyVerification
    #shah
  def index
    render layout: false, content_type: 'application/liquid'
  end

end
