# Preview all emails at http://localhost:3000/rails/mailers/quotation_mailer
class QuotationMailerPreview < ActionMailer::Preview
    
     # send a signup email to the user, pass in the user object that   contains the user's email address
  def send_quotation_received_for_customer()
    customer_id = "4359757579" #params[:customer]
    token = Shop.find_by(shopify_domain: 'clippingpathindia.myshopify.com').shopify_token
    session = ShopifyAPI::Session.new('clippingpathindia.myshopify.com', token)
    ShopifyAPI::Base.activate_session(session)
    customer = ShopifyAPI::Customer.find(customer_id)
    shop = ShopifyAPI::Shop.current
    shop_meta = shop.metafields

    quotation = Quotation.where(:id =>440).select('id, message, quantity, yearly_quantity_id, resize_image, image_width,image_height,created_at').first

    QuotationMailer.send_quotation_received_for_customer(customer, shop, quotation, shop_meta)
  end
  
  def quotation_receive_for_admin()
     customer_id = "4359757579" #params[:customer]
    token = Shop.find_by(shopify_domain: 'clippingpathindia.myshopify.com').shopify_token
    session = ShopifyAPI::Session.new('clippingpathindia.myshopify.com', token)
    ShopifyAPI::Base.activate_session(session)
    customer = ShopifyAPI::Customer.find(customer_id)
    shop = ShopifyAPI::Shop.current
    shop_meta = shop.metafields

    quotation = Quotation.where(:id => 440).select('id, message, quantity, yearly_quantity_id, resize_image, image_width,image_height,created_at').first
   
    QuotationMailer.quotation_receive_for_admin(customer, shop, quotation, shop_meta )
  end

end
