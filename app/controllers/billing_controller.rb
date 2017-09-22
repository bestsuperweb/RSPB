class BillingController < ApplicationController
    include ShopifyApp::AppProxyVerification
    include AppProxyAuth
    layout "print", only: [:invoice_print]
    def index

        unless is_user_logged_in
            redirect_to login_url and return
        end

        connect_to_shopify

        wallets = Wallet.where(:customer_id => logged_in_user_id)
        if wallets.empty?
            @wallet_balance = 0
        else
            @wallet_balance = wallets.last.wallet_balance
        end
     
        @product = ShopifyAPI::Product.find(:all, params: { :product_type => 'Credit bundle' }).first.attributes
        
        @uninvoiced_draft_orders = []
        draft_orders = ShopifyAPI::DraftOrder.where( :customer => { :id => logged_in_user_id })
        draft_orders.sort! {|x,y| y.created_at <=> x.created_at }
        
        draft_orders.each do |draft_order|
            if draft_order.tags.include?('Invoice') and (( draft_order.status == 'open' ) or ( draft_order.status == 'invoice_sent'))
                @uninvoiced_draft_orders.push draft_order
            end
        end
        
        render layout: true, content_type: 'application/liquid'

    end
    
    def invoice
        render layout: true, content_type: 'application/liquid'
    end
    
    def invoice_print
        @print = true
        render layout: true, action: 'invoice', content_type: 'application/liquid'
    end

    def generate_invoice
        order_names ||= params[:order_names]
        customer    ||= params[:customer]
        line_items  = []
        orders      = []
        
        respond_to :html, :json
        unless order_names.nil?
        
            connect_to_shopify
            order_names.each do |order_name|
                order       = ShopifyAPI::Order.where(:name => order_name).first
                orders.push order
                
                line_items.push ShopifyAPI::LineItem.new(   
                                                            :custom     => true,
                                                            :price      => order.subtotal_price,
                                                            :quantity   => 1,  
                                                            :title      => order.name,
                                                            :tax_lines  => order.tax_lines,
                                                            :properties => [{
                                                                :name   => 'order_id',
                                                                :value  => order.id
                                                            }]
                                                            )
            end
            
            draft_order = ShopifyAPI::DraftOrder.new(
                                                      :line_items                   => line_items,
                                                      :customer                     => { :id => customer },
                                                      :use_customer_default_address => true,
                                                      :tags                         => 'Invoice'
                                                    )
            
            if draft_order.save
                
                orders.each do |order|
                    tags        = order.tags 
                    order.tags  = tags.gsub('Unpaid', 'Invoiced')
                    order.save
                end
                
                draft_data                  = {}
                draft_data[:name]           = draft_order.name
                draft_data[:created_at]     = Date.parse(draft_order.created_at).strftime('%d %B %Y')
                draft_data[:total_price]    = "$#{'%.02f' % draft_order.total_price}"
                draft_data[:status]         = draft_order.status
                draft_data[:invoice_url]    = draft_order.invoice_url
                
                render :json => {
                    status: 'success',
                    result: "Invoice for #{draft_order.name} was successfully generated!",
                    draft:  draft_data
                  }
            else
                render :json => {
                    status: 'error',
                    message: 'Internal Server Error!'
                  }
            end
              
        else
            
            render :json => {
                status: 'error',
                message:  'There should be at least 1 order checked.' 
              }
              
        end
        
    end

end
