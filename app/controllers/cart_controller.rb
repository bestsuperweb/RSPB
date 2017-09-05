class CartController < ApplicationController
    include ShopifyApp::AppProxyVerification
    include AppProxyAuth

  def index
     wallets = Wallet.where(:customer_id => logged_in_user_id)
     if wallets.empty?
         @wallet_balance = 0
     else
         @wallet_balance = wallets.last.wallet_balance
     end
     
     render layout: true, content_type: 'application/liquid'
     
  end
  
  def create_order
    connect_to_shopify
    variants    = params[:variants]
    quantity    = params[:quantity]
    customer    = params[:customer]
    line_item   = []
    attributes  = []
    variants.split(',').each do |variant|
        line_item.push ShopifyAPI::LineItem.new( :quantity => quantity,  :variant_id => variant, :taxable => true )
    end
    
    attributes[0] = { :name => 'return_file_format',    :value => params[:return_file_format] }
    attributes[1] = { :name => 'set_margin',            :value => params[:set_margin] }
    attributes[2] = { :name => 'resize_image',          :value => params[:resize_image] }
    attributes[3] = { :name => 'image_height',          :value => params[:image_height] }
    attributes[4] = { :name => 'image_width',           :value => params[:image_width] }
    attributes[5] = { :name => 'message',               :value => params[:message] }
    attributes[6] = { :name => 'additional_comment',    :value => params[:additional_comment] }
    attributes[7] = { :name => 'financial_status',      :value => 'pending' }
    attributes[8] = { :name => 'quotation_id',          :value => params[:quotation_id] }
    
    customer = ShopifyAPI::Customer.find(customer)
    
    order = ShopifyAPI::Order.new(
              :line_items       => line_item,
              :customer         => { :id => customer.id },
              :shipping_address => customer.default_address,
              :note_attributes  => attributes,
              :tags             => 'Unpaid',
              :financial_status => 'paid'
            )
    
    respond_to :html, :json
    
    if order.save
        redirect_url = order_path(order.token) + '?msg=thankyou'
        render :json => {
            status:     'success',    
            redirect:   redirect_url
          }
    else
        render :json => {
            status: 'error',
            messages: 'Internal Server Error!'
          }
    end
        
  end
  
  def wallet
        
        connect_to_shopify
        customer    = params[:customer]
        customer    = ShopifyAPI::Customer.find(customer)
        wallets     = Wallet.where(:customer_id => customer.id)
        if wallets.empty?
         @wallet_balance = 0
        else
         @wallet_balance = wallets.last.wallet_balance
        end
        
        line_item   = []
        attributes  = []
        variants    = params[:variants]
        quantity    = params[:quantity]
        variants.split(',').each do |variant|
            line_item.push ShopifyAPI::LineItem.new( :quantity => quantity,  :variant_id => variant, :taxable => true )
        end
        
        attributes[0] = { :name => 'return_file_format',    :value => params[:return_file_format] }
        attributes[1] = { :name => 'set_margin',            :value => params[:set_margin] }
        attributes[2] = { :name => 'resize_image',          :value => params[:resize_image] }
        attributes[3] = { :name => 'image_height',          :value => params[:image_height] }
        attributes[4] = { :name => 'image_width',           :value => params[:image_width] }
        attributes[5] = { :name => 'message',               :value => params[:message] }
        attributes[6] = { :name => 'additional_comment',    :value => params[:additional_comment] }
        attributes[7] = { :name => 'quotation_id',          :value => params[:quotation_id] }
        
        respond_to :html, :json
      
        if params[:full_pay] == 'true'
            if @wallet_balance.to_f >= params[:subtotal].to_f
                
                order = ShopifyAPI::Order.new(
                          :line_items       => line_item,
                          :customer         => { :id => customer.id },
                          :shipping_address => customer.default_address,
                          :note_attributes  => attributes,
                          :tags             => 'Paid from Wallet',
                          :financial_status => 'paid'
                        )
                
                if order.save
                    wallet_balance = @wallet_balance.to_f - params[:subtotal].to_f
                    wallet = Wallet.new( 
                                            customer_id:        customer.id,
                                            order_id:           order.id,
                                            transection_type:   'debit',
                                            currency:           order.currency,
                                            subtotal:           -params[:subtotal].to_f,
                                            tax:                0,
                                            total:              -params[:subtotal].to_f,
                                            wallet_balance:     wallet_balance
                                        )
                    if wallet.save
                        redirect_url = order_path(order.token) + '?msg=thankyou'
                        render :json => {
                            status:     'success',    
                            redirect:   redirect_url
                          }
                    else
                        render :json => {
                            status: 'error',
                            messages: 'Internal Server Error!'
                          }
                    end
                    
                else
                    render :json => {
                        status: 'error',
                        messages: 'Internal Server Error!'
                      }
                end
                
            else
                render :json => {
                    status: 'error',
                    message: 'You have insufficient Wallet balance to pay for this order.'
                }
            end
        else
            
            draft_order = ShopifyAPI::DraftOrder.new(
                    :line_items                     => line_item,
                    :customer                       => { :id => customer.id },
                    :note_attributes                => attributes,
                    :use_customer_default_address   => true,
                    :tags                           => 'Partially paid from Wallet',
                    :applied_discount               => {
                                                            :title          => "My Wallet",
                                                            :description    => "Paid from My Wallet",
                                                            :value          => @wallet_balance.to_f,
                                                            :value_type     => 'fixed_amount',
                                                            :amount         => @wallet_balance.to_f
                                                        }
                )
            
            
            if draft_order.save
                
                draft_order = ShopifyAPI::DraftOrder.find(draft_order.id)
                attributes  = draft_order.note_attributes
                attributes.push( { :name => 'draft_order_id', :value => draft_order.id } )
                draft_order.save
                
                wallet = Wallet.new( 
                                        customer_id:        customer.id,
                                        draft_order_id:     draft_order.id,
                                        transection_type:   'debit',
                                        currency:           draft_order.currency,
                                        subtotal:           -@wallet_balance.to_f,
                                        tax:                0,
                                        total:              -@wallet_balance.to_f,
                                        wallet_balance:     0
                                    )
                if wallet.save
                    redirect_url = draft_order.invoice_url
                    render :json => {
                            status:     'success',    
                            redirect:   redirect_url
                          }
                else
                    render :json => {
                            status: 'error',
                            messages: "Internal Server Error! #{wallet.errors.full_messages.join(',')}"
                          }
                end
            else
                render :json => {
                        status: 'error',
                        messages: 'Internal Server Error!'
                      }
            end
            
        end
        
  end

end
