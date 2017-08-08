require 'digest/md5'
require 'uri'

module AppProxyAuth

    private
    def secrete_key_one
        return '3dc9d4ed99bb6fb68032ece899a28a7f'
    end

    private
    def secrete_key_two
        return '23454@.com'
    end

    def login_url
        return '/account/login'
    end

    def is_user_logged_in
        http_envs = {}.tap do |envs|
            request.headers.each do |key, value|
              envs[key] = value if key.downcase.starts_with?('http')
            end
        end
        if http_envs["HTTP_X_LOGGED_IN_CUSTOMER"] == "1" && is_logged_in_user_verified == true
            return true
        else
            return false
        end
    end

    private
    def is_logged_in_user_verified
        if(params.has_key?(:hash) && params.has_key?(:token))
            uri_hash = params[:hash]
            token = params[:token]
            uri_data = URI.decode(token)
            user_uri =  uri_data.split(secrete_key_two)
            user_id =  user_uri[0]

            new_hash = Digest::MD5.hexdigest(user_id+ secrete_key_one )
            if (new_hash == uri_hash)
                return true
            end
                return false
        else
            return false
        end
    end

    def logged_in_user_id
        if is_user_logged_in
            return get_logged_in_user_id
        else
            false
        end

    end

    private
    def get_logged_in_user_id
        token = params[:token]
        uri_data = URI.decode(token)
        user_uri =  uri_data.split(secrete_key_two)
        return user_uri[0]
    end

    def connect_to_shopify
        shop_domain = params[:shop]
        token = Shop.find_by(shopify_domain: shop_domain).shopify_token
        session = ShopifyAPI::Session.new(shop_domain, token)
        ShopifyAPI::Base.activate_session(session)
    end

    def hash_method(text)
        Digest::MD5.hexdigest(text+ secrete_key )
    end

end

