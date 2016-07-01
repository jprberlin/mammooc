# encoding: utf-8
# frozen_string_literal: true

source 'https://rubygems.org'

ruby '2.3.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.6'
# Use sqlite3 as the database for Active Record
gem 'pg'
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

gem 'slim-rails'
gem 'redcarpet'

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Phusion Passenger 5 as the app server
gem 'passenger'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# authentication
gem 'devise'
gem 'oauth2'
gem 'omniauth'
gem 'omniauth-oauth2', '1.3.1' # See issue for details: https://github.com/mammooc/mammooc.org/issues/626
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'
gem 'omniauth-github'
gem 'omniauth-linkedin-oauth2'
gem 'omniauth-twitter'
gem 'omniauth-windowslive'
gem 'omniauth-amazon'

# authorization
gem 'cancancan', '~>1.10'

# HTTP api_connection
gem 'rest-client'

# file upload
gem 'paperclip'

# amazon S3 connection
gem 'aws-sdk'

# cron job
gem 'redis'
gem 'sidekiq'
gem 'whenever'

# newsfeed
gem 'public_activity'

gem 'bootstrap-sass'
gem 'font-awesome-sass'

gem 'bootstrap_tokenfield_rails'
gem 'bootstrap-datepicker-rails'

gem 'factory_girl_rails'

gem 'rails-i18n'
gem 'i18n-js'

gem 'http_accept_language'

gem 'config'

gem 'newrelic_rpm'

# for filtering, searching and sorting
gem 'filterrific'
gem 'will_paginate'
gem 'will_paginate-bootstrap'

# for ical-Feed
gem 'icalendar'

#calendar widget
gem 'fullcalendar-rails'
gem 'momentjs-rails'

# support for Cross-Origin Resource Sharing (CORS)
gem 'rack-cors', require: 'rack/cors'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'ruby-debug-passenger'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  gem 'rspec-rails'
  gem 'rspec_junit_formatter'

  gem 'bootstrap-generators'

  gem 'capybara'
  gem 'capybara-selenium'
  gem 'database_cleaner'

  # Run selenium tests headless
  gem 'headless'
  gem 'poltergeist'

  gem 'simplecov', require: false
  gem 'rubocop', require: false
  gem 'rubocop-rspec', require: false
  gem 'coveralls', require: false

  gem 'quiet_assets'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console'
end
