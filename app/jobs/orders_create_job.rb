class OrdersCreateJob < ActiveJob::Base
  def perform(shop_domain:, webhook:)
    shop = Shop.find_by(shopify_domain: shop_domain)

    shop.with_shopify_session do
     
      customer_data= webhook[:customer]
      payment_completed_price = webhook[:total_price]
      customer_id = customer_data["id"]
      payment_details = webhook["payment_details"]
      create_order_confirmed = webhook["confirmed"]
      #if we want to use it through  app settings
      product_genric_attr = Rails.configuration.product_type
      config_product_type_credit = product_genric_attr[:credit_sku_prefix]
      
      line_items =  webhook["line_items"]
      product_type = false
      
      line_items.each do |item|
       
          #if(item[ "sku"] != "CREDIT_586589")
          if(!item[ "sku"].start_with?(config_product_type) )
              product_type = false
              break
          end
        
          product_type = true
      end
      
      if(payment_details.count > 0 && payment_details["credit_card_bin"]=="1" && create_order_confirmed == true && product_type==true)
        
        # find customer by customer_id
        customer = ShopifyAPI::Customer.find(customer_id)
        # retrieve metafield for customer wallet
        customer_wallet_balance_old = ShopifyAPI::Metafield.find(:first,:params=>{:resource => "customers", :resource_id => customer_id, :namespace => "wallet", :key => "wallet_balance"}).value
        
        #console print customer old balance
        customer_wallet_balance = customer_wallet_balance_old.to_f
        customer_wallet_balance_new =   customer_wallet_balance + payment_completed_price.to_f
        
       # puts customer_wallet_balance_new
       customer.add_metafield(ShopifyAPI::Metafield.new(:namespace => "wallet", :key =>  "wallet_balance", :value => customer_wallet_balance_new.to_s, :value_type => "string"))
       customer.metafields
       
       #puts "===============================END ORDER CREATE END ======================================="
        
      end
    end
  end
end
