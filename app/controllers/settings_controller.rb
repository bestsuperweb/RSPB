class SettingsController < ApplicationController
  
  skip_before_filter :verify_authenticity_token
  include ShopifyApp::AppProxyVerification
  include AppProxyAuth

  def index
    connect_to_shopify
    @customer       = ShopifyAPI::Customer.find(logged_in_user_id)
    @order_emails   = ShopifyAPI::Metafield.find(:first,:params=>{  :resource => "customers", 
                                                                    :resource_id => logged_in_user_id, 
                                                                    :namespace => "addtional_emails", 
                                                                    :key => "order_notification_emails" })
    @billing_emails = ShopifyAPI::Metafield.find(:first,:params=>{  :resource => "customers", 
                                                                    :resource_id => logged_in_user_id, 
                                                                    :namespace => "addtional_emails", 
                                                                    :key => "billing_notification_emails" })
    @website_url    = ShopifyAPI::Metafield.find(:first,:params=>{  :resource => "customers", 
                                                                    :resource_id => logged_in_user_id, 
                                                                    :namespace => "company_info", 
                                                                    :key => "website_url" })
    @vat_number     = ShopifyAPI::Metafield.find(:first,:params=>{  :resource => "customers", 
                                                                    :resource_id => logged_in_user_id, 
                                                                    :namespace => "company_info", 
                                                                    :key => "vat_number" })
                                                                    
    @order_emails   = @order_emails.value unless @order_emails.nil?
    @billing_emails = @billing_emails.value unless @billing_emails.nil?
    @website_url    = @website_url.value unless @website_url.nil?
    @vat_number     = @vat_number.value unless @vat_number.nil?
    
    @order_emails   = "," if @order_emails.nil?
    @billing_emails = "," if @billing_emails.nil?
    @website_url    = "" if @website_url.nil?
    @vat_number     = "" if @vat_number.nil?
    
    render layout: true, content_type: 'application/liquid'
  end
  
  def update
  
    if(
        params[:customer][:email].empty? or 
        params[:customer][:name].empty? or 
        params[:customer][:phone].empty? or 
        params[:customer][:address1].empty? or 
        params[:customer][:city].empty? or 
        params[:customer][:postcode].empty?
        )
        
        @result = 'Some fields should be filled.'
        
    else
       
        if( valid_email?(params[:customer][:email]) or valid_url?(params[:customer][:company_website]) )
            
            params[:customer][:order_email].each do |email|
                unless valid_email?(email)
                    @result = 'All emails should be valid.'
                    return
                end
            end
            
            params[:customer][:billing_email].each do |email|
                unless valid_email?(email)
                    @result = 'All emails should be valid.'
                    return
                end
            end
            
            connect_to_shopify
            customer = ShopifyAPI::Customer.find(params[:customer][:id])
            customer.name   = params[:customer][:name]
            customer.phone  = params[:customer][:phone]
            customer.addresses.first.company  = params[:customer][:company]
            customer.addresses.first.phone    = params[:customer][:company_phone]
            customer.addresses.first.address1 = params[:customer][:address1]
            customer.addresses.first.address2 = params[:customer][:address2]
            customer.addresses.first.city     = params[:customer][:city]
            customer.addresses.first.province = params[:customer][:county]
            customer.addresses.first.zip      = params[:customer][:postcode]
            customer.addresses.first.country  = params[:customer][:country]
            
            order_emails    = params[:customer][:order_email].join(',')
            billing_emails  = params[:customer][:billing_email].join(',')
            
            website_url     = params[:customer][:company_website]
            vat_number      = params[:customer][:vat_number]
        
            
            order_emails    = "," if order_emails.empty?
            billing_emails  = "," if billing_emails.empty?
                
            
            meta_field1  = ShopifyAPI::Metafield.new({
                                                :namespace   => 'addtional_emails',
                                                :key         => 'order_notification_emails',
                                                :value       => order_emails,
                                                :value_type  => 'string'
                                            })
            
            meta_field2  = ShopifyAPI::Metafield.new({
                                                :namespace   => 'addtional_emails',
                                                :key         => 'billing_notification_emails',
                                                :value       => billing_emails,
                                                :value_type  => 'string'
                                            })
                                            
            meta_field3  = ShopifyAPI::Metafield.new({
                                                :namespace   => 'company_info',
                                                :key         => 'website_url',
                                                :value       => website_url,
                                                :value_type  => 'string'
                                            })
                                            
            meta_field4  = ShopifyAPI::Metafield.new({
                                                :namespace   => 'company_info',
                                                :key         => 'vat_number',
                                                :value       => vat_number,
                                                :value_type  => 'string'
                                            })
                                            
            customer.add_metafield(meta_field1)
            customer.add_metafield(meta_field2)
            customer.add_metafield(meta_field3)
            customer.add_metafield(meta_field4)
            
            if website_url.empty?
                meta_field = ShopifyAPI::Metafield.find(:first,:params=>{:resource => "customers", 
                                                                         :resource_id => params[:customer][:id], 
                                                                         :namespace => "company_info", 
                                                                         :key => "website_url" })
                meta_field.destroy unless meta_field.nil?
            end
            
            if vat_number.empty?
                meta_field = ShopifyAPI::Metafield.find(:first,:params=>{:resource => "customers", 
                                                                         :resource_id => params[:customer][:id], 
                                                                         :namespace => "company_info", 
                                                                         :key => "vat_number" })
                meta_field.destroy unless meta_field.nil?
            end
            
            
            if  ShopifyAPI::Customer.search(query: "email:#{params[:customer][:email]}").count < 1 
                
                customer.email  = params[:customer][:email]
            
                if customer.save
                    @result = 'All information was successfully updated.' 
                else
                    @result = 'Internal Server error.'
                end
            else
                if customer.email == customer_params[:email]
                    if customer.save
                        @result = 'All information was successfully updated.'
                    else
                        @result = 'Internal Server error.'
                    end
                else
                     @result  = 'That email address is already registered.'
                end
            end
        else
            @result  = 'Some fields should be valide.'
        end
    end
      
  end
  
  private 
    def customer_params
        params.require(:customer).permit( :id,
                                          :name,
                                          :email,
                                          :phone,
                                          :company,
                                          :company_website,
                                          :company_phone,
                                          :vat_number,
                                          :address1,
                                          :address2,
                                          :city,
                                          :county,
                                          :postcode,
                                          :country,
                                          order_email: [],
                                          billing_email: []
                                          )
    end
    
    def valid_email?(email)
        if email.empty?
            return true
        end
        valid_email_regx = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
        (email =~ valid_email_regx)
    end
    
    def valid_url?(uri)
        if uri.empty?
            return true
        end
        uri = URI.parse(uri) && !uri.host.nil?
        rescue URI::InvalidURIError
          false
    end

end

