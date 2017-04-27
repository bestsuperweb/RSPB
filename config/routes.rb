Rails.application.routes.draw do
  root :to => 'home#index'
  mount ShopifyApp::Engine, at: '/'

  if Rails.env.development?
    path_prefix = '/a/portal-dev'
  elsif Rails.env.production?
    path_prefix = '/a/portal'
  end

  scope path_prefix  do
    #root action: 'index'
    resources :articles do
      resources :comments
    end
  end
  
  #namespace :app_proxy do
  #  root action: 'index'
    
  #  resources :articles do
  #    resources :comments
  #  end
    
    #resources :articles
    # simple routes without a specified controller will go to AppProxyController
    
    # more complex routes will go to controllers in the AppProxy namespace
    # 	resources :reviews
    # GET /app_proxy/reviews will now be routed to
    # AppProxy::ReviewsController#index, for example
  #end
  
  get 'pricing/index'

  get 'welcome/index'
  
  #resources :articles do
  #  resources :comments
  #end
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'
end