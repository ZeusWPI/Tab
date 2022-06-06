# frozen_string_literal: true

class CallbacksController < Devise::OmniauthCallbacksController
	# See https://github.com/omniauth/omniauth/wiki/FAQ#rails-session-is-clobbered-after-callback-on-developer-strategy
	skip_before_action :verify_authenticity_token, only: :zeuswpi

	def zeuswpi
		@user = User.from_omniauth(request.env["omniauth.auth"])
		sign_in_and_redirect @user, event: :authentication
	end

	def after_omniauth_failure_path_for(_)
		root_path
	end
end
