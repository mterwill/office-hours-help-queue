source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.4.4'
# Use Puma as the app server
gem 'puma', '~> 3.12.6'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0.6'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '~> 3.0.2'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Use jquery as the JavaScript library
gem 'jquery-rails', '~> 4.2.1'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', '~> 0.12.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.6.0'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 3.3.1'
# Use MySQL for database
gem 'mysql2', '~> 0.4.4'
# Use Google OAuth2 for authentication
gem 'omniauth-google-oauth2', '~> 0.6.0'
# For frontend
gem 'react-rails', '~> 1.8.2'
# For error tracking
gem 'bugsnag', '~> 6.11'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '~> 1.4.8'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', '~> 9.0.5', platform: :mri
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '~> 3.3.1'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', '~> 1.7.2'
  gem 'spring-watcher-listen', '~> 2.0.0'
  # For deployment
  gem 'capistrano',         '~> 3.6.1', require: false
  gem 'capistrano-rvm',     '~> 0.1.2', require: false
  gem 'capistrano-rails',   '~> 1.2.0', require: false
  gem 'capistrano-bundler', '~> 1.2.0', require: false
  gem 'capistrano3-puma',   '~> 1.2.1', require: false

  # https://github.com/net-ssh/net-ssh/issues/565
  gem 'ed25519', '>= 1.2', '< 1.3', require: false
  gem 'bcrypt_pbkdf', '>= 1.0', '< 2.0', require: false
end
