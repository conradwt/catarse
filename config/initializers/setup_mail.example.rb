ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :tls                  => true,
  :address              => 'SMTP_DOMAIN_ADDRESS',
  :port                 => 'PORT',
  :domain               => 'DOMAIN_ADDRESS',
  :user_name            => 'USERNAME',
  :password             => 'PASSWORD',
  :authentication       => 'AUTH_TYPE',
  :enable_starttls_auto => true  
}

ActionMailer::Base.default_url_options[:host] = 'HOST_DOMAIN'
ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?

