class QuotationMailer < ApplicationMailer

#default :from => 'support@clippingpathindia.com'

  def send_quotation_received_for_customer(customer,shop, quotation, shop_meta)
    @customer = customer
    @shop = shop
    @shop_meta = shop_meta
    @quotation = quotation
    @email_title = "Thank you for your quotation request!"
    mail(:to => @customer.email, :subject => 'Thanks for Requesting a Quote at clippingpathindia.com')
  end

  def quotation_receive_for_admin(customer, shop, quotation, shop_meta)
    @customer = customer
    @shop = shop
    @shop_meta = shop_meta
    @quotation = quotation
    @email_title = "Request a Quote - Clipping Path India"
    mail( :to => 'sumonmg@me.com',
    :subject => 'Request a Quote - Clipping Path India' )
  end
end
