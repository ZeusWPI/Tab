# frozen_string_literal: true

class RequestsController < ApplicationController
  load_and_authorize_resource :user, find_by: :name

  before_action :load_request, only: [:confirm, :decline, :cancel]
  authorize_resource :request, id_param: :request_id, only: [:confirm, :decline, :cancel]

  def index
    @requests = @user.requests.group_by(&:status)
    respond_to do |format|
      format.html
      format.json { render json: @requests }
    end
  end

  def confirm
    @request.confirm!
    redirect_to root_path
  end

  def decline
    @request.decline!
    redirect_to root_path
  end

  def cancel
    @request.cancel!
    redirect_to root_path
  end

  private

  def load_request
    @request = Request.find params[:request_id]
  end
end
