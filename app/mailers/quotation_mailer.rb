class QuotationMailer < ApplicationMailer
 
default :from => 'support@clippingpathindia.com'

  # send a signup email to the user, pass in the user object that   contains the user's email address
  def send_quotation_received_for_customer(customer,shop, quotation, shop_meta)
    @customer = customer
    @shop = shop
    @shop_meta = shop_meta
    @quotation = quotation
    @email_title = "Thank you for your quotation request!"
    mail( :to => @customer.email,
    :subject => 'Thanks for Quotation submitting on clippligpathindia.com' )
  end
  
  def quotation_receive_for_admin(customer, shop, quotation, shop_meta)
    @customer = customer
    @shop = shop
    @shop_meta = shop_meta
    @quotation = quotation
    @email_title = "Thank you for your quotation request!"
    mail( :to => 'babubd089@yahoo.com',
    :subject => 'A quotation have been submitted' )
  end
end
