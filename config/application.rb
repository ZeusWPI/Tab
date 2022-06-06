require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Tab
	class Application < Rails::Application
		# Initialize configuration defaults for originally generated Rails version.
		config.load_defaults 7.0

		# Configuration for the application, engines, and railties goes here.
		#
		# These settings can be overridden in specific environments using the files
		# in config/environments, which are processed later.
		#
		config.time_zone = 'Brussels'
		# config.eager_load_paths << Rails.root.join("extras")

		# Which is the lowest balance you should be ashamed of.
		config.shameful_balance = 0 # In eurocents!
		config.maximum_amount = 15000
		config.minimum_balance = 0
	end
end
