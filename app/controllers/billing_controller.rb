class BillingController < ApplicationController
    include ShopifyApp::AppProxyVerification
    include AppProxyAuth

    def index

        unless is_user_logged_in
            redirect_to login_url and return
        end

        connect_to_shopify

        customer_wallet_meta = ShopifyAPI::Metafield.find(:first,:params=>{:resource => "customers", :resource_id => logged_in_user_id, :namespace => "wallet", :key => "wallet_balance"})
        customer_wallet_balance_old = '0.00' if customer_wallet_meta.nil? || customer_wallet_meta.empty? || customer_wallet_meta.blank?
        customer_wallet_balance_old = customer_wallet_meta.value if customer_wallet_balance_old != '0.00'

        @customer_wallet_balance = (customer_wallet_balance_old.to_f > 0) ? customer_wallet_balance_old.to_f : "0.0"

        @product = ShopifyAPI::Product.find(:all, params: { :product_type => 'Credit bundle' }).first.attributes

        render layout: true, content_type: 'application/liquid'

    end

end
