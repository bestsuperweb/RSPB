class SettingsController < ApplicationController
    include ShopifyApp::AppProxyVerification

  def index
    #render layout: false, content_type: 'application/liquid'
  end

end
