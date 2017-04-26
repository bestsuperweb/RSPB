class ArticlesController < ApplicationController

    #include ShopifyApp::AppProxyVerification
    
    #http_basic_authenticate_with name: "sumon", password: "sumon", except: [:index, :show]
        
    def index
        @articles = Article.all
        
        shop = 'clippingpathindia.myshopify.com'
        token = Shop.find_by(shopify_domain: shop).shopify_token
        session = ShopifyAPI::Session.new(shop, token)
        ShopifyAPI::Base.activate_session(session)
        @products = ShopifyAPI::Product.find(:all, params: { limit: 10 })
    end
    
    def show
        @article = Article.find(params[:id])
    end
    
    def new
        @article = Article.new
    end
    
    def edit
        @article = Article.find(params[:id])
    end
    
    def create
        @article = Article.new(article_params)
        
        if @article.save
            redirect_to @article
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
        
        redirect_to articles_path
    end
    
    private
        def article_params
            params.require(:article).permit(:title, :text)
        end
    
    
end
