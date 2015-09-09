class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  def current_client
    @current_client ||= identify_client
  end

  def current_ability
    if current_user
      @current_ability ||= Ability.new(current_user)
    elsif current_client
      @current_ability ||= ClientAbility.new(current_account)
    end
  end

  private

  def identify_client
    key = request.headers["X-API-KEY"]
    Client.find_by key: key if key
  end

end
