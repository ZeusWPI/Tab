# frozen_string_literal: true

source "https://rubygems.org"

ruby "3.4.8"

rails_version = "~> 8.0.0"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Rails: internals.
gem "railties", rails_version

# Rails: Utilities and Ruby extensions.
gem "activesupport", rails_version

# Rails component: Generic models.
gem "activemodel", rails_version

# Rails component: Database-backed models.
gem "activerecord", rails_version
# Slugs instead of ids
gem "friendly_id"
# Use an adapter for SQLite in development, MariaDB in production
gem "sqlite3", group: [:development, :test]
gem "mysql2", group: :production

# Rails component: Controllers that handle HTTP requests.
gem "actionpack", rails_version
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"
# Swagger
gem "rswag-api"
gem "rswag-ui"
gem "rspec-rails", group: [:development, :test]
gem "rswag-specs", group: [:development, :test]
# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Rails component: ERB template engine.
gem "actionview", rails_version

# Rails component: Static assets.
gem "sprockets-rails"
# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Rails component: File upload support.
gem "activestorage", rails_version

# Rails component: Send emails.
gem "actionmailer", rails_version

# Rails component: Delayed jobs.
gem "activejob", rails_version
# Use sidekiq as the queue adapter.
gem "sidekiq"
gem "sidekiq-cron"

# Rails component: Authentication.
gem "devise"
gem "omniauth-oauth2"
gem "omniauth-rails_csrf_protection"
gem "omniauth-zeuswpi"

# Rails component: Authorisation.
gem "cancancan"
gem "rolify"

# These are no longer default gems in newer ruby versions, but some dependencies
# assume they still are.
gem "benchmark"
gem "mutex_m"

# Autoload the .env file
gem "dotenv-rails"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[windows jruby]

# For ./bin/dev
gem "foreman", group: :development

# Linting
gem "rubocop-capybara", group: :development
gem "rubocop-factory_bot", group: :development
gem "rubocop-rails", group: :development
gem "rubocop-rspec", group: :development
gem "rubocop-rspec_rails", group: :development

# Debugging
# Call 'byebug' anywhere in the code to stop execution and get a debugger console
gem "byebug", group: [:development, :test]
# See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
gem "debug", group: [:development, :test], platforms: %i[windows]
# Use console on exceptions pages [https://github.com/rails/web-console]
gem "web-console", group: :development
# Open emails right as you send them in a new tab
gem "letter_opener", group: :development

# Tests
gem "factory_bot_rails", group: [:development, :test]
gem "faker", group: [:development, :test]
gem "rails-controller-testing", group: [:development, :test]
# Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
gem "capybara", group: :test
gem "selenium-webdriver", group: :test
gem "webdrivers", group: :test
# Make sure the database is in a clean state in between tests
gem "database_cleaner-active_record", group: :test

# Deployment
gem "capistrano", group: :development
gem "capistrano-asdf", group: :development
gem "capistrano-passenger", group: :development
gem "capistrano-rails", group: :development
gem "capistrano-sidekiq", group: :development, require: false
# ed25519 ssh key support
gem "bcrypt_pbkdf", group: :development
gem "ed25519", group: :development
