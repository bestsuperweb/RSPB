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
        customer_params[:email].empty? or 
        customer_params[:first_name].empty? or
        customer_params[:last_name].empty? or
        customer_params[:phone].empty? or 
        customer_params[:address1].empty? or 
        customer_params[:city].empty? or 
        customer_params[:postcode].empty?
        )
        
        @result = 'Some fields should be filled.'
        
    else
       
        if( valid_email?(customer_params[:email]) or valid_url?(customer_params[:company_website]) )
            
            customer_params[:order_email].each do |email|
                unless valid_email?(email)
                    @result = 'All emails should be valid.'
                    return
                end
            end
            
            customer_params[:billing_email].each do |email|
                unless valid_email?(email)
                    @result = 'All emails should be valid.'
                    return
                end
            end
            
            connect_to_shopify
            customer                = ShopifyAPI::Customer.find(customer_params[:id])
            customer.first_name     = customer_params[:first_name]
            customer.last_name      = customer_params[:last_name]
            customer.phone          = customer_params[:phone]
            customer.addresses.first.company  = customer_params[:company]
            customer.addresses.first.phone    = customer_params[:company_phone]
            customer.addresses.first.address1 = customer_params[:address1]
            customer.addresses.first.address2 = customer_params[:address2]
            customer.addresses.first.city     = customer_params[:city]
            customer.addresses.first.province = customer_params[:county]
            customer.addresses.first.zip      = customer_params[:postcode]
            customer.addresses.first.country  = customer_params[:country]
            
            order_emails    = customer_params[:order_email].join(',')
            billing_emails  = customer_params[:billing_email].join(',')
            
            website_url     = customer_params[:company_website]
            vat_number      = customer_params[:vat_number]
        
            
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
                                                                         :resource_id => customer_params[:id], 
                                                                         :namespace => "company_info", 
                                                                         :key => "website_url" })
                meta_field.destroy unless meta_field.nil?
            end
            
            if vat_number.empty?
                meta_field = ShopifyAPI::Metafield.find(:first,:params=>{:resource => "customers", 
                                                                         :resource_id => customer_params[:id], 
                                                                         :namespace => "company_info", 
                                                                         :key => "vat_number" })
                meta_field.destroy unless meta_field.nil?
            end
            
            
            if  ShopifyAPI::Customer.search(query: "email:#{customer_params[:email]}").count < 1 
                
                customer.email  = customer_params[:email]
            
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
                                          :first_name,
                                          :last_name,
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

