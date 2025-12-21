require_relative "boot"

require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Tab
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # https://island94.org/2024/11/keep-your-secrets-yml-in-rails-7-2
    config.secrets = config_for(:secrets) # loads from config/secrets.yml
    config.secret_key_base = config.secrets[:secret_key_base]
    def secrets
      config.secrets
    end

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.

    config.active_job.queue_adapter = :sidekiq

    config.time_zone = "Brussels"

    # Which is the lowest balance you should be ashamed of.
    config.shameful_balance = 0 # In eurocents!
    config.maximum_amount = 15_000
    config.minimum_balance = 0
  end
end
