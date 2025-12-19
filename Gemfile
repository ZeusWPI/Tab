# frozen_string_literal: true

source "https://rubygems.org"

ruby "3.4.8"

rails_version = "~> 7.0.0"

# Rails core
gem "railties", rails_version

# Rails components
gem "actioncable", rails_version
gem "actionmailbox", rails_version
gem "actionmailer", rails_version
gem "actionpack", rails_version
gem "actiontext", rails_version
gem "actionview", rails_version
gem "activejob", rails_version
gem "activemodel", rails_version
gem "activerecord", rails_version
gem "activestorage", rails_version
gem "activesupport", rails_version

# These are no longer default gems in newer ruby versions
gem "benchmark"
gem "mutex_m"

# ed25519 ssh key support
gem "bcrypt_pbkdf"
gem "ed25519"

# Support .env files
gem "dotenv-rails"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use sqlite3 as the database for Active Record
gem "sqlite3"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[windows jruby]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Authentication
gem "devise"
gem "omniauth-oauth2"
gem "omniauth-rails_csrf_protection"
gem "omniauth-zeuswpi"

# Authorisation
gem "cancancan"

# Friendly ids!
gem "friendly_id"

gem "rolify"

# Frontend stuff
gem "cssbundling-rails"
gem "jsbundling-rails"

gem "rswag-api"
gem "rswag-ui"

gem "sidekiq"
gem "sidekiq-cron"

group :production do
  gem "mysql2"
end

group :development, :test do
  gem "factory_bot_rails"
  gem "faker"

  gem "rails-controller-testing"
  gem "rspec-rails"
  gem "rswag-specs"

  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "byebug"

  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[windows]
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Open emails right as you send them in a new tab
  gem "letter_opener"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"

  # Deployment
  gem "capistrano"
  gem "capistrano-asdf"
  gem "capistrano-passenger"
  gem "capistrano-rails"
  gem "capistrano-sidekiq", require: false

  # Rubocop so we're all on the same level <3
  gem "rubocop-rails"
  gem "rubocop-rspec"

  # For ./bin/dev
  gem "foreman"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"

  # Make sure the database is in a clean state in between tests
  gem "database_cleaner-active_record"
end
