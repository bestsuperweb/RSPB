class BillingController < ApplicationController
    include ShopifyApp::AppProxyVerification
    #include AppProxyAuth
    
  def index
    #@customer_id = login_to_shopify('verify_logged_in_user')
    @customer_id = 4281588171
    if(@customer_id)
        customer_wallet_meta = ShopifyAPI::Metafield.find(:first,:params=>{:resource => "customers", :resource_id => @customer_id, :namespace => "wallet", :key => "wallet_balance"})
        #delete meta field
        #customer_wallet_meta.destroy
        customer_wallet_balance_old = '0.00' if customer_wallet_meta.nil? || customer_wallet_meta.empty? || customer_wallet_meta.blank?
        if(customer_wallet_balance_old != '0.00')
            customer_wallet_balance_old = customer_wallet_meta.value
        end
        #console print customer old balance
        @customer_wallet_balance = (customer_wallet_balance_old.to_f > 0) ? customer_wallet_balance_old.to_f : "0.0"
        # get credit bundle
        # services = Rails.configuration.product_type
        # product_type_credit_bundles = services[:credit].split(' ').select {|w| w.capitalize! || w }.join(' ')
        
        @product = ShopifyAPI::Product.find(:all, params: { :product_type => 'Credit Bundles' }).first.attributes
        variants = ShopifyAPI::Variant.find(:all, :params => {:product_id => @product['id']})
        
        # variants_all = Array.new(5)
        # counter = 0
        # variants.each do |v|
        #     items = Array.new(2)
        #     items[0] = v.attributes[:title]
        #     items[1] = v.attributes[:title]
        #     variants_all[counter]
        #     counter = counter+1
        #  end
        # puts variants_all
        # puts @product['id']
    end
    render layout: true, content_type: 'application/liquid'
  end

end
