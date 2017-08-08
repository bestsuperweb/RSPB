class DashboardController < ApplicationController
    include ShopifyApp::AppProxyVerification
    include AppProxyAuth
    require 'shopify_api'

    def index

        unless is_user_logged_in
            redirect_to login_url and return
        end

        render layout: true, content_type: 'application/liquid'
    end

end
