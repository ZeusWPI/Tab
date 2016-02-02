class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { render json: [ "Diefstal is een misdrijf." ], status: :forbidden }
      format.html { redirect_to root_url, alert: exception.message }
    end
  end

  def authenticate_user_or_client!
    current_user || current_client || redirect_to(root_path, flash: { notice: "You have been redirected." })
  end

  def current_client
    @current_client ||= authenticate_with_http_token do |token, options|
      Client.find_by key: token
    end
  end

  def current_ability
    @current_ability ||=
      current_client.try { |c| ClientAbility.new(c) } ||
      UserAbility.new(current_user)
  end

  def after_sign_in_path_for(resource)
    current_user
  end
end
