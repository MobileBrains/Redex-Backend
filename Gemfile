source 'https://rubygems.org'

ruby "2.5.0"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.0', '>= 5.0.0.1'

# Use postgresql as the database for Active Record
gem 'pg', '~> 0.19'

# Use Puma as the app server
gem 'puma', '~> 3.0'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'

gem 'sassc'

gem 'bootstrap-sass-extras'



# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'

# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
gem 'sidekiq'

# Manage multiple threads in app start
gem 'foreman'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'
gem 'jquery-turbolinks'

gem 'bootstrap-sass', '~> 3.2.0'
gem 'autoprefixer-rails'

gem 'momentjs-rails', '>= 2.9.0'
gem 'bootstrap3-datetimepicker-rails', '~> 4.14.30'

#Manage the application.yml file
gem 'figaro'

#User Authentication
gem 'devise'

#User permisions
gem 'cancancan'

#User Roles
gem 'rolify'

#Pretty Alert Messages
gem 'toastr-rails'

# CSV, xls, xlsx, etc files Importer
gem 'active_importer'

# Font awasome Icons
gem "font-awesome-rails"
gem 'font-awesome-sass'

gem 'underscore-rails'

#Web Dashboard Administration
gem 'rails_admin', '~> 1.0'

#Google Maps Geocoding tasks handler (Geocoding is the process of converting addresses to longitude - latitude, and more)
gem 'geocoder'

#Google Maps integration
gem 'gmaps4rails'

#Models, Routes and Specs Documentation
gem 'annotate'

# API authentication
gem 'doorkeeper'
gem 'rack-oauth2'

# API
group :api do
  gem 'grape'
  gem 'grape-entity'
  gem 'rack-cors', :require => 'rack/cors'
  gem 'rest-client' # Test API
end

group :development do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri

  gem 'capistrano', '~> 3.10', '>= 3.10.1'
    gem 'capistrano-rvm',     require: false
    gem 'capistrano-rails',   require: false
    gem 'capistrano-bundler', require: false
    gem 'capistrano3-puma',   require: false
    gem 'capistrano-figaro-yml', '~> 1.0.2'
end

group :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
