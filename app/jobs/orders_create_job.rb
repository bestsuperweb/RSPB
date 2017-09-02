class OrdersCreateJob < ActiveJob::Base
    require 'json'

    def perform(shop_domain:, webhook:)
        shop = Shop.find_by(shopify_domain: shop_domain)

        shop.with_shopify_session do
            
            payment_details ||= webhook["payment_details"]
            
            logger.debug "***payment_details"
            
            if payment_details
                if(payment_details.count > 0 && payment_details["credit_card_bin"] == "1" && webhook["confirmed"] == true)
    
                    logger.debug "*** Go to IF"
                    credit_purchase = false
                    service_purchase = false
    
                    line_items =  webhook["line_items"]
    
                    line_items.each do |item|
                        if(item[ "sku"].start_with?('CREDIT_'))
                            credit_purchase = true
                            break
                        else
                            service_purchase = true
                            break
                        end
                    end
    
                    if credit_purchase
                    
                    #     customer_id= webhook[:customer]["id"]
                    #     total_price = webhook[:total_price]
                    #     customer_wallet_balance_old = false
                    #     customer = ShopifyAPI::Customer.find(customer_id)
                    #     customer_wallet_meta = ShopifyAPI::Metafield.find(:first,:params=>{:resource => "customers", :resource_id => customer_id, :namespace => "wallet", :key => "wallet_balance"})
                    #     customer_wallet_balance_old = '0.00' if customer_wallet_meta.nil? || customer_wallet_meta.empty? || customer_wallet_meta.blank?
    
                    #     if(customer_wallet_balance_old != '0.00')
                    #         customer_wallet_balance_old = customer_wallet_meta.value
                    #     end
    
                    #     customer_wallet_balance = (customer_wallet_balance_old.to_f > 0) ? customer_wallet_balance_old.to_f : 0
                    #     customer_wallet_balance_new = customer_wallet_balance + total_price.to_f
    
                    #     customer.add_metafield(ShopifyAPI::Metafield.new(:namespace => "wallet", :key =>  "wallet_balance", :value => customer_wallet_balance_new.to_s, :value_type => "string"))
                    #   customer.metafields
                    
                    elsif service_purchase
                        updateQuotationStatus(webhook[:note_attributes])
                    end
                end
            end
            
            # Save data to wallet...
            if Wallet.where(:order_id => webhook[:id]).empty?
                
                logger.debug "***Order Create Job"
                
                line_items      =  webhook["line_items"]
                wallet_balance  = 0
                
                if line_items[0]["sku"].start_with? 'CREDIT_'
                    
                    wallets = Wallet.where(:customer_id => webhook[:customer][:id])
                    logger.debug "***after wallet #{wallets.empty?}"
                    
                    unless wallets.empty?
                       wallet_balance = wallets.last.wallet_balance + webhook[:total_price].to_f
                    else
                       wallet_balance = webhook[:total_price].to_f
                    end
                    logger.debug "***wallet_balance = #{wallet_balance}"
                    
                    wallet                  = Wallet.new( customer_id: webhook[:customer][:id].to_i )
                    # wallet.webhook_id     = webhook[:id]
                    wallet.order_id         = webhook[:id].to_i
                    wallet.transection_type = 'credit'
                    wallet.payment_method   = 'online'
                    wallet.currency         = webhook[:currency]
                    wallet.wallet_balance   = wallet_balance
                    wallet.subtotal         = webhook[:subtotal_price].to_f
                    wallet.tax              = webhook[:total_tax].to_f
                    wallet.total            = webhook[:total_price].to_f
                    wallet.test             = webhook[:test]
                    logger.debug "***wallet = #{wallet.customer_id}"
                    
                    if wallet.save
                        logger.debug "success to save wallet"
                    else
                        logger.debug "failure to save wallet error: #{wallet.errors.full_messages.join(',')}"
                    end
                end
            end
            
        end
    end


    private
    def updateQuotationStatus(note_attributes)
        quotation_id = false
        note_attributes.each do |note|
            if note['name'] == 'quotation_id'
                quotation_id = note['value'].to_f
                #break
            end
        end

        if quotation_id != false
            q = Quotation.find(quotation_id)
            q.status = 'completed'
            q.save
        end
    end


end
