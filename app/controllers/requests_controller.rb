class RequestsController < ApplicationController
  load_and_authorize_resource :user, find_by: :name

  before_action :load_request, only: [:confirm, :decline]
  authorize_resource :request, only: [:confirm, :decline]

  def index
    @requests = @user.incoming_requests.group_by(&:status)
  end

  def confirm
    @request.confirm!
    redirect_to root_path
  end

  def decline
    @request.decline!
    redirect_to root_path
  end

  private

  def load_request
    @request = Request.find params[:request_id]
  end
end
