Rails.application.routes.draw do
  root :to => 'home#index'
  mount ShopifyApp::Engine, at: '/'

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
  end

  get 'pricing/index'

  get 'welcome/index'
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'
end

#shah alam
