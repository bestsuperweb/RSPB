require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Myapp
  class Application < Rails::Application

    config.action_dispatch.default_headers['P3P'] = 'CP="Not used"'
    config.action_dispatch.default_headers.delete('X-Frame-Options')
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.assets.paths << Rails.root.join("app", "assets", "fonts")
    #config.assets.enabled = true
    #config.assets.paths << "#{Rails.root}/app/assets/fonts"

    # ENV variables
    config.before_configuration do
      env_file = File.join(Rails.root, 'config', 'local_env.yml')
      YAML.load(File.open(env_file)).each do |key, value|
        ENV[key.to_s] = value
      end if File.exists?(env_file)
    end

    # Autoload lib/ folder including all subdirectories by shah alam
    config.autoload_paths += %W(#{config.root}/lib)
    config.autoload_paths += Dir["#{config.root}/lib/**/"]



    config.serve_static_assets = true

     # Rails 5 for cors
     config.middleware.insert 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => [:get, :post, :options]
      end
    end



    config.action_dispatch.default_headers = {
        'Access-Control-Allow-Origin' => '*',
        'Access-Control-Request-Method' => '*'
    }



     Mailgun.configure do |config|
      config.api_key = 'key-05fedebe63ad40f33509bcba7e60c47a'
    end

    config.action_mailer.preview_path = "#{Rails.root}/test/mailers/previews"

    #config.custom_config = config_for(:custom_config)


  end
end
