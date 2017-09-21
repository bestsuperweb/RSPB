class Admin::BillingController < ShopifyApp::AuthenticatedController
    layout 'admin'

    def index

    end

    def generate_invoice
        #puts params.inspect
        render "index"
    end

end
