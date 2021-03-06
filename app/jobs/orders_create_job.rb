class OrdersCreateJob < ActiveJob::Base
    require 'json'

    def perform(shop_domain:, webhook:)
        shop = Shop.find_by(shopify_domain: shop_domain)

        shop.with_shopify_session do

            logger.debug "Order Update Jobs"
            # Modify financial_status in note_attributes and tag of order from draft order
            if webhook[:tags].include? 'Invoice'
                line_items = webhook[:line_items]
                logger.debug "line_items"
                line_items.each do |line_item|
                    order_id    = line_item[:properties][0][:value] if line_item[:properties][0][:name] == 'order_id'
                    logger.debug "order_id = #{order_id}"
                    order       = ShopifyAPI::Order.find(order_id)
                    logger.debug "order_name = #{order.name}"
                    unless order.nil?
                        tags       = order.tags
                        order.tags = tags.gsub('Invoiced', 'Paid')
                        attributes = order.note_attributes
                        logger.debug "note_attributes = #{attributes.inspect}"
                        attributes.each_with_index do |attribute, index|
                            attributes[index].value = 'paid' if attribute.name == 'financial_status'
                        end
                        logger.debug "note_attributes = #{attributes.inspect}"
                        order.note_attributes = attributes
                        if order.save
                            logger.debug "Success to update order"
                        else
                            logger.debug "Failure to update order"
                        end
                    end
                end
            end

            # Save data to wallet when purchasing credit bundle...
            if Wallet.where(:order_id => webhook[:id]).empty?

                logger.debug "***Order Create Job"

                line_items      =  webhook["line_items"]
                wallet_balance  = 0
                
                if line_items[0]["sku"]
                    is_credit   = line_items[0]["sku"].start_with? 'CREDIT_'
                else
                    is_credit   = false
                end
                
                if is_credit or webhook[:tags].include? 'Wallet top-up'

                    wallets = Wallet.where(:customer_id => webhook[:customer][:id])
                    logger.debug "***after wallet #{wallets.empty?}"

                    unless wallets.empty?
                       wallet_balance = wallets.last.wallet_balance + webhook[:subtotal_price].to_f
                    else
                       wallet_balance = webhook[:subtotal_price].to_f
                    end
                    logger.debug "***wallet_balance = #{wallet_balance}"

                    wallet                  = Wallet.new( customer_id: webhook[:customer][:id].to_i )
                    wallet.order_id         = webhook[:id].to_i
                    wallet.transection_type = 'credit'
                    wallet.payment_method   = webhook[:gateway]
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
            
            #Update data when creating order...
            quotation_id     = nil
            template_id      = nil
            draft_order_id   = nil
            
            webhook[:note_attributes].each do |attribute|
                quotation_id    = attribute[:value] if attribute[:name] == 'quotation_id'
                template_id     = attribute[:value] if attribute[:name] == 'template_id'
                draft_order_id  = attribute[:value] if attribute[:name] == 'draft_order_id'
            end
            
            logger.debug "***Update Quotation Job #{quotation_id}"
            unless quotation_id.empty?
                updateQuotationStatus(webhook[:note_attributes])
            end
            
            logger.debug "***Update order_id(#{webhook[:id]}) of wallet with draft_order_id#{draft_order_id}"
            unless draft_order_id.nil?
                wallet = Wallet.where(:draft_order_id => draft_order_id).last
                wallet.order_id = webhook[:id]
                if wallet.save
                    logger.debug "***success to save new wallet data"
                else
                    logger.debug "***failure to save new wallet data ( #{wallet.errors.full_messages.join(',')} )"
                end
            end
            
            logger.debug "*** Template Update Job #{template_id}"
            unless template_id.empty?
                template = Template.find(template_id)
                template.times_used = template.times_used.to_i + 1
                template.last_used_at = Time.now
                if template.save
                    logger.debug "***success to update template"
                else
                    logger.debug "***failure to update template ( #{template.errors.full_messages.join(',')} )"
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
            if q.save
                logger.debug "***success to update quotation"
            else
                logger.debug "***failure to update quotation ( #{q.errors.full_messages.join(',')} )"
            end
        end
    end


end
