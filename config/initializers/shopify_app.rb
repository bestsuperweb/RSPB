ShopifyApp.configure do |config|
  config.application_name = "My Shopify App"
  config.api_key = "8d61f4cc21e49ec91dff4c139e780f08"
  config.secret = "29c03a9112790dbde6952a26a5b9a212"
  config.scope = "read_orders, read_products"
  config.embedded_app = true
end
