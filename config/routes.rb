Rails.application.routes.draw do
  root :to => 'admin/home#index'
  mount ShopifyApp::Engine, at: '/'

  namespace :admin do
    root 'home#index'
    resources :quotations
    get '/billing', to: 'billing#index', as: 'billing'
    get '/settings', to: 'settings#index', as: 'settings'

    ## Temporary routes
    resources :articles do
      resources :comments
    end

    get 'pricing/index'
    get 'welcome/index'
    ## Temporary routes end
  end

#### Routes for customer portal
  get '/a/portal-shahalam', to: redirect('/a/portal-shahalam/dashboard')
  get '/a/portal', to: redirect('/a/portal/dashboard')

  if Rails.env.development?
    path_prefix = '/a/portal-shahalam'
  elsif Rails.env.production?
    path_prefix = '/a/portal'
  end

  scope path_prefix  do
    resources :articles do
      resources :comments
    end

    get '/dashboard', to: 'dashboard#index', as: 'dashboard'

    resources :quotations
    #resources :customers

    get '/billing', to: 'billing#index', as: 'billing'
    get '/settings', to: 'settings#index', as: 'settings'
    get '/templates', to: 'templates#index', as: 'templates'
    get '/cart', to: 'cart#index', as: 'cart'
  end
#### Routes for customer portal end


  # Default route came with rails, have to check what to do with it.
  root 'welcome#index'
end