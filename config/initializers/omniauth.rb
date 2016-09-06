OmniAuth.config.logger = Rails.logger

OmniAuth.config.full_host = Rails.env.production? ? 'https://eecs.help' : 'http://dev.eecs.help:3000'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider(
    :google_oauth2,
    ENV['GOOGLE_CLIENT_ID'],
    ENV['GOOGLE_CLIENT_SECRET'],
    hd: ENV['GOOGLE_HD'],
    access_type: 'online'
  )
end
