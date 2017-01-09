class RequestsController < ApplicationController
  load_and_authorize_resource :user,    only: :index

  before_action :load_request, only: [:confirm, :decline]
  authorize_resource :request, only: [:confirm, :decline]

  def index
    @requests = User.find(params[:user_id]).incoming_requests.group_by(&:status)
  end

  def confirm
    @request.confirm!
    redirect_to user_requests_path(@request.debtor)
  end

  def decline
    @request.decline!
    redirect_to user_requests_path(@request.debtor)
  end

  private

  def load_request
    @request = Request.find params[:request_id]
  end
end
