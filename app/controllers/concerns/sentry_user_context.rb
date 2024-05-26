# frozen_string_literal: true

module SentryUserContext
  extend ActiveSupport::Concern

  included do
    before_action :set_sentry_context
  end

  private

  def sentry_user_context
    {}.tap do |user|
      next unless current_user

      user[:id] = current_user.id
      user[:name] = current_user.name
    end
  end

  def set_sentry_context
    Sentry.set_user(sentry_user_context)
  end
end
