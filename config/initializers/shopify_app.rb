ShopifyApp.configure do |config|
  config.application_name = "CPI Test App on Dev"
  config.api_key = "5447c868ceae16b1c8457d2c80136845"
  config.secret = "d39c62acf9f6155036b4179fd11ee8f5"
  config.scope = "read_content, write_content, read_themes, write_themes, read_products, write_products, read_customers, write_customers, read_orders, write_orders, read_draft_orders, write_draft_orders, read_script_tags, write_script_tags, read_fulfillments, write_fulfillments, read_shipping, write_shipping, read_analytics"
  config.embedded_app = true
end
