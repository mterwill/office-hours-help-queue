OmniAuth.config.logger = Rails.logger

# OmniAuth.config.full_host = Rails.env.production? ? 'https://domain.com' : 'http://localhost:3000'
OmniAuth.config.full_host = 'http://dev.eecs.help:3000'
    # provider :google_oauth2, ENV["GOOGLE_CLIENT_ID"], ENV["GOOGLE_CLIENT_SECRET"]

Rails.application.config.middleware.use OmniAuth::Builder do
  provider(
    :google_oauth2,
    ENV['GOOGLE_CLIENT_ID'],
    ENV['GOOGLE_CLIENT_SECRET'],
    # hd: ENV['GOOGLE_HD'],
    access_type: 'online'
  )
end
