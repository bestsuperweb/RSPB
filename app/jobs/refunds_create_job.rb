class RefundsCreateJob < ActiveJob::Base
  def perform(shop_domain:, webhook:)
    shop = Shop.find_by(shopify_domain: shop_domain)

    shop.with_shopify_session do
      if Wallet.where([ "refund_id = ? and order_id = ?", webhook[:id], webhook[:order_id] ]).empty? 
        logger.debug "***Refund Create Job"
        
        if webhook[:refund_items][0][:line_item][:sku].start_with? 'CREDIT_'
          
          sub_total       = 0
          total_tax       = 0
          total_price     = -webhook[:transactions][0][:amount].to_f
          wallet_balance  = 0
          
          order = ShopifyAPI::Order.find(webhook[:order_id])
          if order.tax_lines.empty?
            sub_total = total_price
          else
            sub_total = total_price / ( 1 + order.tax_lines.first.rate.to_f )
          end
          
          total_tax = total_price - sub_total
          
          wallets = Wallet.where(:customer_id => order.customer.id)
          unless wallets.empty?
            wallet_balance = wallets.last.wallet_balance + sub_total
          else
            wallet_balance = sub_total
          end
          
          logger.debug "***wallet_balance= #{wallet_balance}"
          wallet                    = Wallet.new( customer_id: order.customer.id )
          wallet.order_id           = webhook[:order_id].to_i
          wallet.refund_id          = webhook[:id].to_i
          wallet.transection_type   = 'debit'
          wallet.payment_method     = 'online'
          wallet.currency           = webhook[:transactions][0][:currency]
          wallet.subtotal           = sub_total
          wallet.tax                = total_tax
          wallet.total              = total_price
          wallet.wallet_balance     = wallet_balance
          wallet.test               = webhook[:transactions][0][:test]
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
end
