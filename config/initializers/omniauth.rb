Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  require 'openid/store/filesystem'
  provider :openid, :store => OpenID::Store::Filesystem.new('./tmp'), :name => 'google', :identifier => 'https://www.google.com/accounts/o8/id'

#  provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
end
