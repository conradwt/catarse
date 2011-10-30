Catarse::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = false

  # Compress JavaScripts and CSS
  config.assets.compress = true
  
  # Choose the compressors for CSS files.
  # config.assets.css_compressor = :yui
  
  # Choose the compressors for Javascript files.
  # config.assets.js_compressor = :closure
  # config.assets.js_compressor  = :uglifier
  # config.assets.js_compressor = :yui

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false # default
  # config.assets.compile = true

  # Generate digests for assets URLs
  config.assets.digest = true

  # Defaults to Rails.root.join("public/assets")
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store
  
  # Disable Rails's static asset server
  # In production, Apache or nginx will already do this
  config.serve_static_assets = false  # TK: Rails 3.0

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  config.assets.precompile += %w( 
                                  back_notices.js
                                  back_project.js
                                  banda.js
                                  controllers/project.js
                                  credit.js
                                  embed.js
                                  explore_projects.js
                                  flash.js
                                  guidelines.js
                                  login.js
                                  models/backer.js
                                  models/comment.js
                                  models/paginated_collection.js
                                  models/project.js
                                  models/project_collection.js
                                  models/update.js
                                  models/user.js
                                  notification.js
                                  pending_backers.js
                                  pending_projects.js
                                  press.js
                                  profile.js
                                  project_embed.js
                                  project_form.js
                                  promo_top.js
                                  review.js
                                  show_project.js
                                  slider.js
                                  start_project.js
                                  user.js
                                  views/project/about.js
                                  views/project/backer.js
                                  views/project/comment.js
                                  views/project/model.js
                                  views/project/paginated_comment.js
                                  views/project/project_backers.js
                                  views/project/project_comment.js
                                  views/project/project_updates.js
                                  views/project/update.js
                                 )

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify
  config.active_record.schema_format = :sql # TK: Rails 3.0
  
  config.action_mailer.delivery_method = Mailee::Mailer
end
