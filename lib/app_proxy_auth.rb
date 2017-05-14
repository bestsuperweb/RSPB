require 'digest/md5'
require 'uri'

module AppProxyAuth
   
   
    
    private
    def secrate_key
        secret_key = '3dc9d4ed99bb6fb68032ece899a28a7f' 

    end
    
    public
    def hash_method(email)
        
        Digest::MD5.hexdigest(email+ secrate_key )
     
    end
    
    def decript_token()
        
        token = params[:token]
        uri_data = URI.decode(token)
        user_uri =  uri_data.split("23454@.com") 
        id =  user_uri[0]
       # @user_data['id'] = id
        if(token)
            return true
        else
            return false
        end
       
    end
    
    def is_logged_user_request
        
        http_envs = {}.tap do |envs|
        request.headers.each do |key, value|
          envs[key] = value if key.downcase.starts_with?('http')
        end
      end
      
        loggedinuser = http_envs["HTTP_X_LOGGED_IN_CUSTOMER"]
         
    end
    
    def check_user_auth
        
        uri_hash = params[:hash]
        token = params[:token]
        uri_data = URI.decode(token)
        user_uri =  uri_data.split("23454@.com") 
        id =  user_uri[0]
        
        new_hash = Digest::MD5.hexdigest(id+ secrate_key )
        if (new_hash == uri_hash)
            return true
        end
        
            return false
        
    end
    
   def verify_user()
      if(params[:hash] && params[:token])
          
           if(decript_token()&& is_logged_user_request() && check_user_auth())
              cpi_app_shop_login()
           else
              #redirect_to('https://cpiv.myshopify.com/account/login')
              #return "Your are trying manualy!"
             return false
           end
       
       else
           return false
      end
       
   end
   
   
   def cpi_app_shop_login
       
    shop_domain = params[:shop]
       
    token = Shop.find_by(shopify_domain: shop_domain).shopify_token
      
    session = ShopifyAPI::Session.new(shop_domain, token)
      
    ShopifyAPI::Base.activate_session(session)
       
   end
   
   
   
   def login_to_shopify(verify_logged_in_user = false)
     
       if (verify_logged_in_user )
           
           if( verify_user())
                #session[:current_user_id] =  @user_data['id']
                token = params[:token]
                uri_data = URI.decode(token)
                user_uri =  uri_data.split("23454@.com") 
                id =  user_uri[0]
                return customer =id
            else
                
                 return false
            end
          
       else
          cpi_app_shop_login()
          #return false
         
      end
       
   end
 
end
    
