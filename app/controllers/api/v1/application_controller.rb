# frozen_string_literal: true

module Api
	module V1
		class ApplicationController < ActionController::Base
			skip_before_action :verify_authenticity_token

			before_action :require_login!

			def require_login!
				return true if authenticate_user_or_client!

				render json: { errors: [{ detail: "Access denied" }] }, status: :unauthorized
			end

			def authenticate_user_or_client!
				current_user_or_client
			end

			def current_user_or_client
				current_user || current_client
			end

			def current_user
				@current_user ||= authenticate_with_http_token do |token, _|
					User.find_by(key: token)
				end
			end

			def current_client
				@current_client ||= authenticate_with_http_token do |token, _|
					Client.find_by key: token
				end
			end

			def current_ability
				@current_ability ||= current_client.try { |c| ClientAbility.new(c) } || UserAbility.new(current_user_or_client)
			end

			rescue_from CanCan::AccessDenied do |_|
				render json: { errors: [{ detail: "Diefstal is een misdrijf" }] }, status: :forbidden
			end
		end
	end
end
