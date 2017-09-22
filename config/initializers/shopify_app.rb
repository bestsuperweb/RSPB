ShopifyApp.configure do |config|
    config.application_name   = ENV['SHOIFY_APP_NAME']
    config.api_key            = ENV['SHOPIFY_CLIENT_API_KEY']
    config.secret             = ENV['SHOPIFY_CLIENT_API_SECRET']
    config.scope              = "read_content, write_content, read_themes, write_themes, read_products, write_products, read_customers, write_customers, read_orders, write_orders, read_draft_orders, write_draft_orders, read_script_tags, write_script_tags, read_fulfillments, write_fulfillments, read_shipping, write_shipping, read_analytics, read_checkouts, write_checkouts, read_reports, write_reports"
    config.embedded_app       = false
    config.webhooks           = [
                                  {
                                    topic: 'orders/create',
                                    address: 'https://'+ENV['ENV_HOST']+'/webhooks/orders_create',
                                    format: 'json'
                                  },
                                  {
                                    topic: 'draft_orders/delete',
                                    address: 'https://'+ENV['ENV_HOST']+'/webhooks/draft_orders_delete',
                                    format: 'json'
                                  },
                                  {
                                    topic: 'refunds/create',
                                    address: 'https://'+ENV['ENV_HOST']+'/webhooks/refunds_create',
                                    format: 'json'
                                  },
                                ]
end