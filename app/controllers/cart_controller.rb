class CartController < ApplicationController
    include ShopifyApp::AppProxyVerification
    include AppProxyAuth

  def index
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
        line_item.push ShopifyAPI::LineItem.new( :quantity => quantity,  :variant_id => variant )
    end
    
    attributes[0] = { :name => 'return_file_format',    :value => params[:return_file_format] }
    attributes[1] = { :name => 'set_margin',            :value => params[:set_margin] }
    attributes[2] = { :name => 'resize_image',          :value => params[:resize_image] }
    attributes[3] = { :name => 'image_height',          :value => params[:image_height] }
    attributes[4] = { :name => 'image_width',           :value => params[:image_width] }
    attributes[5] = { :name => 'message',               :value => params[:message] }
    attributes[6] = { :name => 'additional_comment',    :value => params[:additional_comment] }
    
    order = ShopifyAPI::Order.new(
              :line_items       => line_item,
              :customer         => { :id => customer },
              :note_attributes  => attributes,
              :financial_status => 'pending'
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
            messages: order
          }
    end
        
  end

end
