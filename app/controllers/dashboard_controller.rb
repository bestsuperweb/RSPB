class DashboardController < ApplicationController
    include ShopifyApp::AppProxyVerification
    include AppProxyAuth

    def index

        unless is_user_logged_in
            redirect_to login_url and return
        end
        
        @templates = Template.where( :customer_id => logged_in_user_id).order('times_used, last_used_at DESC')
        
        render layout: true, content_type: 'application/liquid'
    end

end
