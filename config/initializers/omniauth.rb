OmniAuth.config.logger = Rails.logger

OmniAuth.config.full_host = Rails.env.production? ? ENV['FULL_HOST'] : 'http://dev.eecs.help:3000'

Rails.application.config.middleware.use OmniAuth::Builder do
  if Rails.env.production?
    provider(
      :google_oauth2,
      ENV['GOOGLE_CLIENT_ID'],
      ENV['GOOGLE_CLIENT_SECRET'],
      hd: ENV['GOOGLE_HD'],
      access_type: 'online'
    )
  else
    # Do not specify the hosted domain in dev so you log in with accounts other than umich
    provider(
      :google_oauth2,
      ENV['GOOGLE_CLIENT_ID'],
      ENV['GOOGLE_CLIENT_SECRET'],
      access_type: 'online'
    )
  end
end
