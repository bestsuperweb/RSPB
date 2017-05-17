class HomeController < ShopifyApp::AuthenticatedController
  def index
    @products = ShopifyAPI::Product.find(:all)
    #@metafields = ShopifyAPI::Metafield.find(:all, params: { limit: 10 })
    #@metafield_count = ShopifyAPI::Metafield.count
    render layout: 'admin'
  end
end
