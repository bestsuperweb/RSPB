class AppProxyController < ApplicationController
   include ShopifyApp::AppProxyVerification

  def index
    @articles = Article.all
    #render layout: true, content_type: 'application/liquid'
  end

end
