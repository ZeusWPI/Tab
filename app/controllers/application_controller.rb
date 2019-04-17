class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  protect_from_forgery with: :exception
  # Don't verfiy authenticity token (protects against CSRF) for API requests
  skip_before_action :verify_authenticity_token, if: :api_request?

  def api_request?
    (user_token.present? || current_client.present?) && request.format.json?
  end

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { render json: [ "Diefstal is een misdrijf." ], status: :forbidden }
      format.html { redirect_to root_url, alert: exception.message }
    end
  end

  def authenticate_user_or_client!
    current_user || current_client || user_token || redirect_to(root_path, flash: { notice: "You have been redirected." })
  end

  def current_client
    @current_client ||= authenticate_with_http_token do |token, options|
      Client.find_by key: token
    end
  end

  def current_ability
    @current_ability ||=
      current_client.try { |c| ClientAbility.new(c) } ||
      UserAbility.new(current_user || user_token)
  end

  def user_token
    @user_token ||= authenticate_with_http_token do |token, options|
      User.find_by key: token
    end
  end

  def after_sign_in_path_for(resource)
    root_path
  end
end
