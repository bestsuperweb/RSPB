class Admin::HomeController < ShopifyApp::AuthenticatedController
  def index
    @products = ShopifyAPI::Product.find(:all)
    render layout: 'admin'
  end
end
