class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  def authenticate_user_or_client!
    current_user || current_client || head(:unauthorized)
  end

  def current_client
    @current_client ||= Client.find_by key: request.headers["X-API-KEY"]
  end

  def current_ability
    if current_user
      @current_ability ||= Ability.new(current_user)
    elsif current_client
      @current_ability ||= ClientAbility.new(current_client)
    end
  end
end
