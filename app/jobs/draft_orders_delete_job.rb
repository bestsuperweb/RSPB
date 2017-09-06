class DraftOrdersDeleteJob < ActiveJob::Base
  require 'json'
  
  def perform(shop_domain:, webhook:)
    shop = Shop.find_by(shopify_domain: shop_domain)

    shop.with_shopify_session do
      
      logger.debug "*** Delete wallet where draft order id = #{webhook[:id]}"
      
      wallets = Wallet.where(:draft_order_id => webhook[:id])
      unless wallets.nil?
        wallet = wallets.last
        if wallet.destroy
          logger.debug "*** success to delete wallet with draft_order_id = #{webhook[:id]}"
        else
          logger.debug "*** failure to delete wallet with draft_order_id = #{webhook[:id]} ( #{wallet.errors.full_messages.join(',')} )"
        end
      else
        logger.debug "*** no wallet with draft_order_id = #{webhook[:id]}"
      end
      
    end
    
  end
  
end
