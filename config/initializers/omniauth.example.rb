require 'omniauth/openid'
require 'openid/store/filesystem'

Rails.application.config.middleware.use OmniAuth::Builder do  
  # providers with id/secret, you need to sign up for their services (see below) and enter the parameters here
  provider :facebook, APP_ID, SECRET
  provider :twitter,  APP_ID, SECRET
  # provider :github, 'CLIENT ID', 'SECRET'
  
  # generic openid
  # provider :openid, OpenID::Store::Filesystem.new('./tmp'), :name => 'openid'
  
  # dedicated openid
  provider :openid, OpenID::Store::Filesystem.new('./tmp'), :name => 'google', :identifier => 'https://www.google.com/accounts/o8/id'
  # provider :google_apps, OpenID::Store::Filesystem.new('./tmp'), :name => 'google_apps'
  # /auth/google_apps; you can bypass the prompt for the domain with /auth/google_apps?domain=somedomain.com
  
  provider :openid, OpenID::Store::Filesystem.new('./tmp'), :name => 'yahoo', :identifier => 'yahoo.com' 
  # provider :openid, OpenID::Store::Filesystem.new('./tmp'), :name => 'aol', :identifier => 'openid.aol.com'
  # provider :openid, OpenID::Store::Filesystem.new('./tmp'), :name => 'myopenid', :identifier => 'myopenid.com'
  
  # begin
  #   OauthProvider.all.each do |p|
  #     # This hack can be removed after the upgrade to omniauth 2.0
  #     # Where every provider will accept the options hash
  #     unless p.scope.nil?
  #       provider p.strategy, p.key, p.secret, {:scope => p.scope}
  #     else
  #       provider p.strategy, p.key, p.secret
  #     end
  #   end
  # rescue Exception => e
  #   # We should initialize even with errors during providers setup
  #   Rails.logger.error "Error while setting omniauth providers: #{e.inspect}"
  # end
end