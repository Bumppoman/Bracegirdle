source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '6.1.3.1'

# Use Puma as the app server
gem 'puma'

# Use SCSS for stylesheets
gem 'sassc-rails'

# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker'

# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'

# Use ActiveModel has_secure_password
 gem 'bcrypt'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

# Use PostgreSQL for production
gem 'pg'

group :development do
  # Use Capistrano for deployment
  gem 'capistrano'
  gem 'capistrano-rails'
  gem 'capistrano-rvm'
  gem 'capistrano3-puma'

  gem 'better_errors'
  gem 'binding_of_caller'
  
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  #gem 'spring'
  #gem 'spring-watcher-listen'
  #gem 'spring-commands-rspec'
  
  gem 'listen'
end


group :test do
  gem 'rspec-rails'
  gem 'rspec-retry'
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'capybara-choices'

  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'

  # To determine test coverage
  #gem 'simplecov', '< 0.18.0', require: false
  gem 'simplecov', require: false

  # To test PDFs
  gem 'pdf-inspector'

  # To stub request
  gem 'webmock'
  
  gem 'rack_session_access'
  gem 'byebug'
end

# For geocoding cemetery locations
gem 'geocoder'

gem "rubyzip"

# For submitting files through Ajax
gem 'remotipart'

# For generating PDFs
gem 'prawn'
gem 'prawn-table'
gem 'combine_pdf'
gem 'squid'

# For using PDF.js with Rails
gem 'pdfjs_viewer-rails'

# Language processing
gem 'numbers_and_words'
gem 'indefinite_article'

# For Auth0
gem 'omniauth'
gem 'omniauth-auth0'
gem 'omniauth-rails_csrf_protection'

gem 'pundit'
