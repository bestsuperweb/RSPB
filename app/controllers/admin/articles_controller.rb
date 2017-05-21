class Admin::ArticlesController < ApplicationController

    layout 'admin'

    skip_before_filter :verify_authenticity_token

    #include ShopifyApp::AppProxyVerification

    #include AppProxyAuth

    #http_basic_authenticate_with name: "sumon", password: "sumon", except: [:index, :show]

    def index
        # flash.keep
        @articles = Article.all

        # shop = 'clippingpathindia.myshopify.com'
        # shop = params[:shop]

        # token = Shop.find_by(shopify_domain: shop).shopify_token
        # session = ShopifyAPI::Session.new(shop, token)
        # ShopifyAPI::Base.activate_session(session)
        # @products = ShopifyAPI::Product.find(:all, params: { limit: 10 })
        # render layout: true, content_type: 'application/liquid'
    end

    def show
        #flash.keep[:success] = "Great job! Article saved"
        @article = Article.find(params[:id])
    end

    def new
        @article = Article.new
    end

    def edit
        @article = Article.find(params[:id])
    end

    def create

        #login_to_shopify(verify_logged_in_user)

        @article = Article.new(article_params)

        if @article.save
            redirect_to admin_article_path(@article, success: "Thank you! Your request has been received. We'll look at it and get back to you with your quotation soon.")
        else
            render 'new'
        end
    end

    def update
        @article = Article.find(params[:id])

        if @article.update(article_params)
            redirect_to @article
        else
            render 'edit'
        end
    end

    def destroy
        @article = Article.find(params[:id])
        @article.destroy

        redirect_to admin_articles_path
    end

    private
        def article_params
            params.require(:article).permit(:title, :text)
        end


end
