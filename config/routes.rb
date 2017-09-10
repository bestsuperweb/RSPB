Rails.application.routes.draw do
  root :to => 'admin/home#index'
  mount ShopifyApp::Engine, at: '/'

  namespace :admin do
    root 'quotations#index'
    #get "" => redirect("/admin/quotations")
    resources :quotations
    get '/billing', to: 'billing#index', as: 'billing'
    get '/settings', to: 'settings#index', as: 'settings'
    post '/settings/turnaround_multipliers', to: 'settings#turnaround_multipliers', as: 'turnaround_multipliers'
    post '/settings/volume_discounts', to: 'settings#volume_discounts', as: 'volume_discounts'
    post '/settings/product_variants', to: 'settings#product_variants', as: 'product_variants'
    get '/quotations_samples', to: 'quotations#samples', as: 'quotations_samples'
    get '/search', to: 'quotations#search_filter'

    ## Temporary routes
    get '/pricing', to: 'pricing#index'
    get 'welcome/index'

    resources :articles do
      resources :comments
    end
    ## Temporary routes end
  end

#### Routes for customer portal
  get Rails.configuration.custom_config['proxy_path'], to: redirect(Rails.configuration.custom_config['proxy_path']+'/dashboard')

  scope Rails.configuration.custom_config['proxy_path']  do
    resources :articles do
      resources :comments
    end

    get '/dashboard', to: 'dashboard#index', as: 'dashboard'

    resources :quotations
    #resources :customers

    get '/dashboard/new_order/:id', to: 'dashboard#new_order', as: 'new_order'
    get '/dashboard/load_templates/:id', to: 'dashboard#load_templates', as: 'load_templates'
    get '/dashboard/order/:token', to: 'dashboard#order', as: 'order'
    post '/dashboard/draft/delete/:id', to: 'dashboard#draft_order_delete', as: 'draft_order_delete'
    get '/billing', to: 'billing#index', as: 'billing'
    post '/billing/generate/invoice', to: 'billing#generate_invoice', as: 'generate_invoice'
    get '/billing/invoice/:token', to: 'billing#invoice', as: 'invoice'
    get '/billing/invoice_print/:token', to: 'billing#invoice_print', as: 'invoice_print'
    get '/settings', to: 'settings#index', as: 'settings'
    post '/update/settings', to: 'settings#update', as: 'settings_update'
    get '/templates', to: 'templates#index', as: 'templates'
    post    '/create/template', to: 'templates#create', as: 'create_template'
    delete  '/delete/template/:id',  to: 'templates#delete', as: 'delete_template'
    put     '/update/template/:id',  to: 'templates#update', as: 'update_template'
    get '/cart', to: 'cart#index', as: 'cart'
    post '/cart/create_order', to: 'cart#create_order', as: 'create_order'
    post '/cart/wallet', to: 'cart#wallet', as: 'cart_wallet'
    get 'pricing/index'
    get 'pricing/need'
  end
#### Routes for customer portal end


  # Default route came with rails, have to check what to do with it.
  root 'welcome#index'
end