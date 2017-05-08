class HomeController < ShopifyApp::AuthenticatedController
  def index

=begin    
    metadata = {
      'namespace': 'quotations',
      'key': 1234,
      'value': 'Name: Atiqur Rahman Sumon, E-mail: sumonmg@me.com',
      'value_type': 'string',
      'owner_resource': 'customers',
      'description': 'Creating the first quotation using API into the metafield.'
    }
  
    if ShopifyAPI::Metafield.new(metadata).save
      @meta_create_status = 'yes'
    else
       @meta_create_status = 'no'
    end
=end

    @products = ShopifyAPI::Product.find(:all)
    @metafields = ShopifyAPI::Metafield.find(:all, params: { limit: 10 })
    @metafield_count = ShopifyAPI::Metafield.count
  end
end
